class UsersController < ApplicationController
  authorize_resource

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
    @user = @account.users.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
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
    if current_user.has_role? :super
      @user = User.get(params[:id])
    else
      @user = @account.users.get(params[:id])
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = @account.users.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(users_url, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = @account.users.get(params[:id])
    if params[:user][:password].empty? && params[:user][:password_confirmation].empty?
      params[:user].delete('password')
      params[:user].delete('password_confirmation')
    end

    respond_to do |format|
      if @user.update(params[:user])
        #@current_ability = nil
        #@current_user = nil
        format.html { redirect_to(users_url, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = @account.users.get(params[:id])
    @user.destroy if @user

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
