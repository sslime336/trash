package ds

import "sync"

type (
	// BPItem 用于数据记录
	BPItem struct {
		Key int64
		Val any
	}

	BPNode struct {
		MaxKey int64     // 子树的最大关键字
		Nodes  []*BPNode // 节点的子树
		Items  []BPItem  // 节点的数据，若该节点为索引节点，Items 为 nil
		Next   *BPNode   // 用于叶子结点的链表
	}
)

type BPTree struct {
	mu   sync.RWMutex
	root *BPNode
	// width 为B+树的阶, halfw 用于 M/2 = ceil(M/2)
	width, halfw int
}

func NewLeafNode(width int) *BPNode {
	node := new(BPNode)
	node.Items = make([]BPItem, 0, width+1)
	return node
}

func NewBPTree(width int) *BPTree {
	if width < 3 {
		width = 3
	}
	bt := new(BPTree)
	bt.root = NewLeafNode(width)
	bt.width = width
	bt.halfw = (bt.width + 1) / 2
	return bt
}

func (t *BPTree) Get(key int64) any {
	t.mu.Lock()
	defer t.mu.Unlock()

	node := t.root
	for i := 0; i < len(node.Nodes); i++ {
		if key <= node.Nodes[i].MaxKey {
			node = node.Nodes[i]
			i = 0
		}
	}

	if len(node.Nodes) > 0 {
		return nil
	}

	for i := 0; i < len(node.Items); i++ {
		if node.Items[i].Key == key {
			return node.Items[i].Val
		}
	}

	return nil
}

func (t *BPTree) Set(key int64, value any) {
	t.mu.Lock()
	defer t.mu.Unlock()
	t.setValue(nil, t.root, key, value)
}

func (t *BPTree) setValue(parent, node *BPNode, key int64, value any) {
	for i := 0; i < len(node.Nodes); i++ {
		if key <= node.Nodes[i].MaxKey || i == len(node.Nodes)-1 {
			t.setValue(node, node.Nodes[i], key, value)
			break
		}
	}
	if len(node.Nodes) < 1 {
		node.setValue(key, value)
	}
}

func (n *BPNode) setValue(key int64, value any) {

}
