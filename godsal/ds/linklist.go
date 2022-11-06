package ds

type SingleLinkedList struct {
	Head *Node
	Tail *Node
	Len  int
}

type Node struct {
	Next  *Node
	Value any
}

type DoubleLinkedList struct {
	Head, Tail *DNode
}

type DNode struct {
	Prev, Next *DNode
	Value      any
}
