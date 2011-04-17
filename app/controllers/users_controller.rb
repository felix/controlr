class UsersController < ApplicationController
  authorize_resource

  rescue_from DataMapper::ObjectNotFoundError do |exception|
    redirect_to users_path, :alert => t('users.missing')
  end

  # GET /users
  # GET /users.xml
  def index
    @users = @account.users.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    redirect_to edit_user_path(params[:id])
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = @account.users.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    if current_user.role? :super
      @user = User.get!(params[:id])
    else
      @user = @account.users.get!(params[:id])
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = @account.users.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = t('users.create.notice')
        format.html { redirect_to(users_url) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        flash[:alert] = t('users.create.alert')
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = @account.users.get!(params[:id])
    if params[:user][:password].blank?
      params[:user].delete('password')
      params[:user].delete('password_confirmation')
    end

    respond_to do |format|
      if @user.update(params[:user])
        flash[:notice] = t('users.update.notice')
        #@current_ability = nil
        #@current_user = nil
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
      else
        flash[:alert] = t('users.update.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = @account.users.get!(params[:id])
    @user.destroy

    respond_to do |format|
      flash[:notice] = t('users.destroy.notice')
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
