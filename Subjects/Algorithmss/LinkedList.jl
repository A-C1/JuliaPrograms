module LinkedList
    

abstract type AbstractNode end

mutable struct Node{S <: Any} <: AbstractNode
    data::S
    next::Node{S}

    # For initializing unreferenced Node
    function Node(data)
        S = typeof(data)
        x = new{S}()
        x.data = data
        x.next = x

        return x
    end
end

# mutable struct NodeNew <: AbstractNode
#     data::Int64
#     next::NodeNew
    
#     function NodeNew(data)
#         x = new()
#         x.data = data
#         x.next = x
#     end
# end

# mutable struct LinkedList{T<:AbstractNode}
#     startNode::T
#     endNode::T
# end

# function insert_at_end(node::T, L::LinkedList) where T <: AbstractNode
#     L.endNode.next = node
#     L.endNode = node
# end

# # Create first Node
# A = Node{Node}(1)
# println(A)

# # Create a linked-list
# L = LinkedList(A,A)
# println(A)

# # Add another node
# B = Node{Node}(2)
# println(B)

# # Add nodeB to the linkedList L
# insert_at_end(B,L)    
# N = Node{Node}
# insert_at_end(N(3), L)
# insert_at_end(N(4), L)
# insert_at_end(N(5), L)
# insert_at_end(N(6), L)
# insert_at_end(N(7), L)

# function printList(L)
#     currentNode = L.startNode
#     while currentNode != L.endNode
#         println(currentNode.data)
#         currentNode = currentNode.next
#     end
# end

# printList(L)

# ## Testing the new type of Node
# # Create first Node
# A = NodeNew(1)
# println(A)

# # Create a linked-list
# L = LinkedList(A,A)
# println(A)

# # Add another node
# B = NodeNew(2)
# println(B)

# # Add nodeB to the linkedList L
# insert_at_end(B,L)    
# N = NodeNew
# insert_at_end(N(3), L)
# insert_at_end(N(4), L)
# insert_at_end(N(5), L)
# insert_at_end(N(6), L)
# insert_at_end(N(7), L)

end