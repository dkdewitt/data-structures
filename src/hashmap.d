import linkedlist;
import std.stdio;
struct HashMap(K, V){

    alias Nodes = Node!(K,V);
    alias Item = Node!(K,V);
    LinkedList!Nodes buckets[] ;

    this(size_t bucketCount)
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


    size_t hashToIndex(size_t hash) const pure nothrow @safe @nogc
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
        hash_t hash = item.generateHash();
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

enum bool storeHash = !isBasicType!K;

private:
    import std.traits : isBasicType;
    struct Node(K, V){
        K key;
        V value;
     
        hash_t hash;
        

    hash_t generateHash() @trusted
{
    import std.functional : unaryFun;
    hash_t h = typeid(K).getHash(&value);
    //writeln(h);
    h ^= (h >>> 20) ^ (h >>> 12);
    return h ^ (h >>> 7) ^ (h >>> 4);
}
}
}

    hash_t generateHash(T)(T value) @trusted
{
    import std.functional : unaryFun;
    hash_t h = typeid(T).getHash(&value);
    h ^= (h >>> 20) ^ (h >>> 12);
    return h ^ (h >>> 7) ^ (h >>> 4);
}

void main() {
    auto t1 = HashMap!(string, string)(4);

    t1.insert("Test", "Test");
    t1.insert("1234", "12342");
    t1.insert("Dwwq1234", "Davi22d");
    t1.insert("David", "Davi2233d");
    t1.insert("Test", "Teswwwt");
    t1["Roger"] = "Smith";
    writeln(t1);
    writeln(t1["Test"]);

}

