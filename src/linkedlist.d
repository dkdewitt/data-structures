module linkedlist;

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
        _count = _count + lst2.length;
    }

    T getFirst(){
        return firstNode.data;
    }

    T getLast(){
        return lastNode.data;
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
                //write(", ");
            temp = temp.next;
            

        }

        return s;
    }

}