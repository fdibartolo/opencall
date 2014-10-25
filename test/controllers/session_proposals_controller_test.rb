require 'test_helper'

class SessionProposalsControllerTest < ActionController::TestCase
  setup do
    @session_proposal = session_proposals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:session_proposals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create session_proposal" do
    assert_difference('SessionProposal.count') do
      post :create, session_proposal: {  }
    end

    assert_redirected_to session_proposal_path(assigns(:session_proposal))
  end

  test "should show session_proposal" do
    get :show, id: @session_proposal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @session_proposal
    assert_response :success
  end

  test "should update session_proposal" do
    patch :update, id: @session_proposal, session_proposal: {  }
    assert_redirected_to session_proposal_path(assigns(:session_proposal))
  end

  test "should destroy session_proposal" do
    assert_difference('SessionProposal.count', -1) do
      delete :destroy, id: @session_proposal
    end

    assert_redirected_to session_proposals_path
  end
end
