# frozen_string_literal: true

class WorkspacesController < ApplicationController
  before_action :set_workspace, only: %i[show edit update destroy switch_to]

  # GET /workspaces or /workspaces.json
  def index
    @workspaces = Workspace.all
  end

  def switch_to
    self.current_workspace = @workspace
    redirect_to root_path
  end

  # GET /workspaces/1 or /workspaces/1.json
  def show; end

  # GET /workspaces/new
  def new
    @workspace = Workspace.new
  end

  # GET /workspaces/1/edit
  def edit; end

  # POST /workspaces or /workspaces.json
  def create
    @workspace = Workspace.new(workspace_params)
    @workspace.user = Current.user
    respond_to do |format|
      if @workspace.save
        handle_successful_creation(format)
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @workspace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workspaces/1 or /workspaces/1.json
  def update
    respond_to do |format|
      if @workspace.update(workspace_params)
        format.html { redirect_to root_path, notice: 'Workspace was successfully updated.', status: :see_other }
        format.json { render :show, status: :ok, location: @workspace }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @workspace.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workspaces/1 or /workspaces/1.json
  def destroy
    @workspace.destroy!

    respond_to do |format|
      format.html { redirect_to workspaces_path, notice: 'Workspace was successfully destroyed.', status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def handle_successful_creation(format)
    self.current_workspace = @workspace
    format.html { redirect_to root_url, notice: 'Workspace was successfully created.' }
    format.json { render :show, status: :created, location: @workspace }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_workspace
    @workspace = Current.user.workspaces.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def workspace_params
    params.expect(workspace: %i[user_id title])
  end
end
