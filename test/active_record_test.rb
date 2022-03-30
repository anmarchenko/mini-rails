require 'test_helper'

class ActiveRecordTest < Minitest::Test
  def test_initialize
    post = Post.new(id: 1, title: "My first post")
    assert_equal 1, post.id
    assert_equal "My first post", post.title
  end

  def test_find
    post = Post.find(1001)
    assert_kind_of Post, post
    assert_equal 1001, post.id
    assert_equal "My first post", post.title
  end

  def test_all
    post = Post.all.first
    assert_kind_of Post, post
    assert_equal 1001, post.id
    assert_equal "My first post", post.title
  end

  def test_execute
    rows = Post.connection.execute("SELECT * FROM posts")
    assert_kind_of Array, rows
    row = rows.first
    assert_kind_of Hash, row
    assert_equal [:id, :title, :body, :created_at, :updated_at], row.keys
  end

  def test_where
    relation = Post.where("id = 1001").where("title IS NOT NULL")
    assert_equal "SELECT * FROM posts WHERE id = 1001 AND title IS NOT NULL", relation.to_sql
    post = relation.first
    assert_kind_of Post, post
    assert_equal 1001, post.id
    assert_equal "My first post", post.title
  end
end
