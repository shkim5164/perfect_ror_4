class HomeController < ApplicationController
  def index
    @post = Post.new
  end
  
  def create
   @html_post = Post.new
    @html_post.title = params[:title]
    @html_post.content = params[:content]
    @html_post.radio = params[:gender]
    @html_post.checkbox = params[:vehicle]
    @html_post.save
    
    redirect_to '/home/links'
    
  end
  
  def links
     @post = Post.find(1)
  end
  
  def once
    @post = Post.find(params[:id])
    
  end
  
  def blank
  end
  
end
