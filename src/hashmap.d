import linkedlist;
import std.stdio;
struct HashMap(K, V){

    alias Nodes = Node!(K,V);
    alias Item = Node!(K,V);
    LinkedList!Nodes buckets[] ;

    this(size_t bucketCount = 16)
    in
    {
        assert ((bucketCount & (bucketCount - 1)) == 0, "bucketCount must be a power of two");
    }
    body
    {
        foreach(i; 0..bucketCount){
            auto list =  LinkedList!Nodes();
            buckets ~= list;
        }
    }


    size_t hashToIndex(size_t hash) const 
    in
    {
        assert (buckets.length > 0);
    }
    out (result)
    {
        assert (result < buckets.length);
    }
    body
    {
        return hash & (buckets.length - 1);
    }


    K[] keys()  @property

    {
        import std.array : appender;
        auto app = appender!(K[])();
        foreach (ref  bucket; buckets)
        {
            foreach (item; bucket.toArray)
                app.put(item.key);
        }
        return app.data;
    }

    void insert(K key,V value){
        auto item = Node!(K,V)(key,value);
        hash_t hash = generateHash(key);
        size_t index = hashToIndex(hash);
        //Check this

        foreach(ref bucketItem; buckets[index].toArray ){
            if (bucketItem.generateHash() == hash && bucketItem.key == key)
                {
                    bucketItem.value = value;
                    return;
                }        
            
            else if (bucketItem.key == key)
                {
                    item.value = value;
                    return;
                }

            else{
                auto node = Node!(K,V)(key,value);
                buckets[index].insert(node);
                return;
            }
}
            auto node  = Node!(K,V)(key, value);
            buckets[index].insert(node);
    }

    V get(K key){
        return this[key];
    }

    V opIndex(K key) 
    {
        import std.algorithm : find;
        import std.exception : enforce;
        import std.conv : text;
        if (buckets.length == 0)
            throw new Exception("'" ~ text(key) ~ "' not found in HashMap");
        size_t hash = generateHash(key);
        size_t index = hashToIndex(hash);
        foreach (r; buckets[index].toArray())
        {
                if (r.generateHash() == hash && r.key == key)
                    return r.value;
            
                else
            {
                if (r.key == key)
                    return r.value;
            }
        }
        throw new Exception("'" ~ text(key) ~ "' not found in HashMap");
    }

    void opIndexAssign(V value, K key)
    {
        insert(key, value);
    }


    /**
    * Check is HashMap contains specific Key
    */
    bool containsKey(K key){
        size_t hash = generateHash(key);
        size_t index = hashToIndex(hash);
        if(buckets.length == 0){
            throw new Exception("'" ~ key ~ "' not found in HashMap" );
            }

        foreach(r; buckets[index].toArray){
            
            if(r.key == key)
                return true;
        }
        
        return false;
    }

string toString(){
    string s;
    foreach(bucket; buckets){
        foreach(r; bucket.toArray){
            s~= "Key: " ~ r.key ~ ", Value: " ~ r.value ~ " \n"  ;
        } //s~= "\n";
    }
    return s;
}


private:
    import std.traits : isBasicType;
    struct Node(K, V){
        K key;
        V value;
     
        hash_t hash;
        }
}

hash_t generateHash(T)(T value)
{
    
        hash_t h = typeid(T).getHash(&value);
        h ^= (h >>> 20) ^ (h >>> 12);
        return h ^ (h >>> 7) ^ (h >>> 4);
}

void main() {
    auto h1 = HashMap!(string, string)(16);
    h1["Apple"] = "Fruit";
    h1["Carrot"] = "Vegetable";

    writeln(h1);
    writeln(h1["Carrot"]);

    writeln(h1.keys);
    //writeln(h1.values);


}

