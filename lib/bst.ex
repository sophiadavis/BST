defmodule BST do
  @moduledoc """
  Functions for creating and manipulating binary search trees.
  """
    
  @doc """
  Insert a value into tree.
  """
  def insert(nil, value) do
    %{value: value, ltree: nil, rtree: nil}
  end
  
  def insert(tree, value) do
    cond do
      value > tree[:value] -> 
        %{value: tree[:value], ltree: tree[:ltree], rtree: insert(tree[:rtree], value)}
      value < tree[:value] -> 
        %{value: tree[:value], ltree: insert(tree[:ltree], value), rtree: tree[:rtree]}
      true -> tree
    end
  end
  
  @doc """
  Remove value from tree.
  """
  def remove(nil, _) do
    nil
  end
  
  def remove(tree, value) do
    cond do
      value > tree[:value] -> 
        %{value: tree[:value], ltree: tree[:ltree], rtree: remove(tree[:rtree], value)}
      value < tree[:value] -> 
        %{value: tree[:value], ltree: remove(tree[:ltree], value), rtree: tree[:rtree]}
      value == tree[:value] ->
        move_up_subtree(tree)
      true -> tree
    end
  end
  
  # If node to remove has no left subtree, replace it with right subtree.
  defp move_up_subtree(%{ltree: nil, rtree: rtree}) do
    rtree
  end
  
  # Otherwise, recursively move up the next-largest value (located in node 
  #   farthest to the right of left subtree).
  defp move_up_subtree(%{ltree: ltree} = tree) do
    {value, ltree} = move_up_most_right_node(ltree)
    %{tree | value: value, ltree: ltree}
  end
  
  # If there is no right subtree, just return the left subtree.
  defp move_up_most_right_node(%{rtree: nil, ltree: ltree, value: value}) do
    { value, ltree }
  end
  
  # While there is a right subtree, swap higher values upwards.
  defp move_up_most_right_node(%{rtree: rtree} = tree) do
    { value, rtree } = move_up_most_right_node(rtree)
    { value, %{tree | rtree: rtree} }
  end

  
  @doc """
    Create a list of all elements in tree, traversing nodes in-order.
  """
  def inorder tree do
    total = inorder tree, []
    Enum.reverse(total)
  end 
  
  defp inorder nil, accum do
    accum
  end
  
  defp inorder tree, accum do
    left_side = inorder tree[:ltree], accum
    middle = [tree[:value]|left_side]
    inorder tree[:rtree], middle
  end
  
  @doc """
    Create a list of all elements in tree, traversing nodes pre-order.
  """
  def preorder tree do
    total = preorder tree, []
    Enum.reverse(total)
  end 
  
  defp preorder nil, accum do
    accum
  end
  
  defp preorder tree, accum do
    middle = [tree[:value]|accum]# accum ++ [tree[:value]]
    left_side = preorder tree[:ltree], middle
    preorder tree[:rtree], left_side
  end
  
  @doc """
    Create a list of all elements in tree, traversing nodes post-order.
  """
  def postorder tree do
    postorder tree, []
  end 
  
  defp postorder nil, accum do
    accum
  end
  
  defp postorder tree, accum do
    left_side = postorder tree[:ltree], accum
    right_side = postorder tree[:rtree], left_side
    right_side ++ [tree[:value]]
  end
  
  @doc """
    Create a list of all elements in tree, traversing nodes in level order.
  """
  def bfs tree do
    acc = [tree[:value]]
    bfs [tree], acc
  end
  
  defp bfs(queue, acc) when length(queue) > 0 do
    current = List.last(queue)    
    queue = List.delete(queue, current)
        
    if current[:ltree] do
      acc = [current[:ltree][:value]|acc]
      queue = [current[:ltree]|queue]
    end
    if current[:rtree] do
      acc = [current[:rtree][:value]|acc]
      queue = [current[:rtree]|queue]
    end
    bfs queue, acc
  end
  
  defp bfs _, acc do
    Enum.reverse acc
  end
end
