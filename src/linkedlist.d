module linkedlist;
import std.stdio;

/*
void main() {
    LinkedList!int buckets[] ;
    foreach(val; 0..50){
        buckets ~= LinkedList!int(val);
    }
    auto b = buckets[5];
    foreach(bucket; b.toArray){
        writeln(bucket);
    }
    //writeln(buckets[1]);

}
*/
struct LinkedList(T)
{

private:
    struct Node
    {
        T data;
        Node* prev;
        Node* next;
        
        this(T n, Node* prev=null, Node* next=null){
            this.data = n;
            this.prev = prev;
            this.next = next;
        }
    }

    Node* getFirstNode(){
        return firstNode;
    }



    Node* firstNode;
    Node* lastNode;
    size_t _count;
    
   public:



    this(T)(T node){
        _count += 1;
        Node* n1 = new Node(node, lastNode);
        firstNode = n1;
        lastNode = n1;
    }

    @property size_t length()   
    {
        return _count;
    }

    T opIndex(size_t t1){
        Node* tmp = firstNode;
        int i = 0;
        while (i < t1){
            tmp = tmp.next;
            i++;
        } 
        return (tmp.data);
    }

    size_t opDollar() const
    {
        return _count;
    }


    
    void insert(T)(T newNode)
    {
        _count += 1;
        
        if(firstNode is null) {
            firstNode = new Node(newNode);
            lastNode = firstNode;
        } else {
            Node* n = new Node(newNode, lastNode);
            lastNode.next = n;
            lastNode = n;
        }
    }

    void insertFirst(T)(T newNode){
        Node* tmp = firstNode;
        Node* n = new Node(newNode);
        n.next = tmp;
        firstNode = n;
    }

    void insertAfter(T)(T newNode, size_t index)
    {
        Node* tmp = firstNode;
        int i = 0;
        while (i < index){
            tmp = tmp.next;
            i++;
        } 
        Node* n1 = tmp.next;
        Node* n = new Node(newNode);
        tmp.next = n;
        if(n1 == lastNode)
            lastNode = n;
        else
            n.next = n1;
    }

    T popFront(){
            Node* n = firstNode;
            T data = n.data;
            firstNode = n.next;
            _count--;
            return data;
    }

    void merge(LinkedList lst2){
        Node* n1st = lst2.getFirstNode();
        lastNode.next = n1st;
        lastNode = lst2.lastNode;
        _count = _count + lst2.length;
    }

    T getFirst(){
        return firstNode.data;
    }

    T getLast(){
        return lastNode.data;
    }

    bool contains(T node){
        if(_count == 0){
            return false;
        }
        else{
            int i = 0;
            Node* tmp = firstNode;
            while(i < _count){

                if(tmp.data == node ){
                    return true;
                }
                tmp = tmp.next;
                i++;

            }
            return false; 
        }
    }

    T[] toArray(){
        T[] returnArray;
        Node* tmp = firstNode;
        while(tmp){
            returnArray ~= tmp.data;
            tmp = tmp.next;
        }
        return returnArray;
    }
    string toString()
    {
        import std.conv;
        string s;
        Node* temp = firstNode;
        while(temp != null){
            s ~= to!string(temp.data);
            //write(temp.data);
            if (temp.next)
                s ~= ", ";

            temp = temp.next;
            

        }

        return s;
    }

    Range opSlice()
    {
        if (this._count == 0)
            return Range(null);
        else
            return Range(firstNode);
    }

    /**
    * Defines the linkedlist range
    */
    struct Range
    {
        private Node*  _head;

        private this(Node* n) 
        { 
            _head = n; 
        }

        // Range empty 
        @property bool empty() const { return false; }

        /// ditto
        @property ref T front()
        {
            assert(!empty, "LinkedList Range is empty");
            return _head.data;
        }

        // Range pop front
        void popFront()
        {
            assert(!empty, "LinkedList Range is empty");
            _head = _head.next;
        }

        /// Forward range primitive.
        @property Range save() { return this; }

        T moveFront()
        {
            import std.algorithm : move;

            assert(!empty, "LinkedList Range is empty");
            return move(_head.data);
        }


    }



}