defmodule BSTTest do
  use ExUnit.Case, async: true
  
  def basic_tree do
    tree = BST.insert(nil, 3)
    tree1 = BST.insert(tree, 5)
    tree2 = BST.insert(tree1, 7)
    tree3 = BST.insert(tree2, 1)
    tree4 = BST.insert(tree3, 2)
    tree4
  end

  test "in order" do
    assert BST.inorder(basic_tree) == [1, 2, 3, 5, 7]
  end
  
  test "pre order" do
    assert BST.preorder(basic_tree) == [3, 1, 2, 5, 7]
  end
  
  test "post order" do
    assert BST.postorder(basic_tree) == [2, 1, 7, 5, 3]
  end
  
  test "bfs" do
    assert BST.bfs(basic_tree) == [3, 1, 5, 2, 7]
  end
  
  test "it removes leaves" do
    assert BST.inorder(BST.remove(basic_tree, 2)) == [1, 3, 5, 7]
  end
  
  test "it removes existing nodes" do
    assert BST.inorder(BST.remove(basic_tree, 1)) == [2, 3, 5, 7]
    assert BST.inorder(BST.remove(basic_tree, 5)) == [1, 2, 3, 7]
  end
  
  test "it removes the root" do
    assert BST.inorder(BST.remove(basic_tree, 3)) == [1, 2, 5, 7]
  end
  
  test "it returns the tree when removing non-existant value" do
    assert BST.inorder(BST.remove(basic_tree, 1000)) == [1, 2, 3, 5, 7]
    assert BST.inorder(BST.remove(basic_tree, -1000)) == [1, 2, 3, 5, 7]
    assert BST.inorder(BST.remove(basic_tree, 6)) == [1, 2, 3, 5, 7]
  end
  
  test "it removes the root from a big tree" do
    :random.seed({743, 327, 2})

    tree = Enum.reduce(Enum.shuffle(1..100), nil,
                       fn x, tree -> BST.insert(tree, x) end)
    
    Enum.reduce 1..100, {tree, Enum.to_list(1..100)}, fn x, {tree, list} ->
      tree = BST.remove(tree, x)
      list = List.delete(list, x)
      assert BST.inorder(tree) == list
      {tree, list}
    end
  end
end
