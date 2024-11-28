abstract type AbstractNode end

mutable struct Node{T<:AbstractNode} <: AbstractNode
    data::Int64
    next::T

    # For initializing a unreferenced node
    function Node{T}(data) where T<: AbstractNode
        x = new{T}()
        x.data = data
        x.next = x
        return x
    end
end

mutable struct LinkedList{T<:AbstractNode}
    startNode::T
    endNode::T
end

function insert(node::Node, L::LinkedList)
    L.endNode.next = node
    L.endNode = node
end

# Creat first node
A = Node{Node}(1)
println(A)

# Create a linked list
L = LinkedList(A,A)
println(L)

# Add another node
B = Node{Node}(2)
println(B)

# Add node B to the linkedlist L
insert(B, L)
N = Node{Node}
insert(N(3), L)
insert(N(4), L)
insert(N(5), L)
insert(N(6), L)
insert(N(7), L)

function printList(L)
    currentNode = L.startNode
    while currentNode != L.endNode
        println(currentNode.data)
        currentNode = currentNode.next
    end
end




