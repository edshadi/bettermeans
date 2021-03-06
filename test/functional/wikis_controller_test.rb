# BetterMeans - Work 2.0
# Copyright (C) 2009  Shereef Bishay
#

require File.dirname(__FILE__) + '/../test_helper'
require 'wikis_controller'

# Re-raise errors caught by the controller.
class WikisController; def rescue_action(e) raise e end; end

class WikisControllerTest < ActionController::TestCase
  fixtures :projects, :users, :roles, :members, :member_roles, :enabled_modules, :wikis
  
  def setup
    @controller = WikisController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil
  end
  
  def test_edit_routing
    assert_routing(
    #TODO: use PUT
      {:method => :post, :path => 'projects/ladida/wiki'},
      :controller => 'wikis', :action => 'edit', :id => 'ladida'
    )
  end
  
  def test_create
    @request.session[:user_id] = 1
    assert_nil Project.find(3).wiki
    post :edit, :id => 3, :wiki => { :start_page => 'Start page' }
    assert_response :success
    wiki = Project.find(3).wiki
    assert_not_nil wiki
    assert_equal 'Start page', wiki.start_page
  end
  
  def test_destroy_routing
    assert_routing(
      {:method => :get, :path => 'projects/ladida/wiki/destroy'},
      :controller => 'wikis', :action => 'destroy', :id => 'ladida'
    )
    assert_recognizes(  #TODO: use DELETE and update form
      {:controller => 'wikis', :action => 'destroy', :id => 'ladida'},
      {:method => :post, :path => 'projects/ladida/wiki/destroy'}
    )
  end
  
  def test_destroy
    @request.session[:user_id] = 1
    post :destroy, :id => 1, :confirm => 1
    assert_redirected_to :controller => 'projects', :action => 'settings', :id => 'ecookbook', :tab => 'wiki'
    assert_nil Project.find(1).wiki
  end
  
  def test_not_found
    @request.session[:user_id] = 1
    post :destroy, :id => 999, :confirm => 1
    assert_response 404
  end
end 
