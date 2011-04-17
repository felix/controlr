class AccountsController < ApplicationController
  authorize_resource

  rescue_from DataMapper::ObjectNotFoundError do |exception|
    redirect_to root_path, :alert => t('accounts.missing')
  end

  # GET /accounts
  # GET /accounts.xml
  def index
    @accounts = Account.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.get!(params[:id])
    # this is the only action that selects the current account for super
    session[:current_account_id] = @account.id || current_user.account.id

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.get!(params[:id])
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])

    respond_to do |format|
      if @account.save
        flash[:notice] = t('accounts.create.notice')
        format.html { redirect_to(@account) }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        flash[:alert] = t('accounts.create.alert')
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.get!(params[:id])

    respond_to do |format|
      if @account.update(params[:account])
        flash[:notice] = t('accounts.update.notice')
        format.html { redirect_to(@account) }
        format.xml  { head :ok }
      else
        flash[:alert] = t('accounts.update.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.get!(params[:id])
    @account.destroy

    respond_to do |format|
      flash[:notice] = t('accounts.destroy.notice')
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
end
