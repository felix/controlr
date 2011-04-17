class DefaultAliasesController < ApplicationController
  authorize_resource

  rescue_from DataMapper::ObjectNotFoundError do |exception|
    redirect_to default_aliases_path, :alert => t('default_aliases.missing')
  end

  # GET /default_aliases
  # GET /default_aliases.xml
  def index
    @default_aliases = @account.default_aliases.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @default_aliases }
    end
  end

  # GET /default_aliases/1
  # GET /default_aliases/1.xml
  def show
    redirect_to edit_default_alias_path(params[:id])
  end

  # GET /default_aliases/new
  # GET /default_aliases/new.xml
  def new
    @default_alias = @account.default_aliases.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @default_alias }
    end
  end

  # GET /default_aliases/1/edit
  def edit
    @default_alias = @account.default_aliases.get!(params[:id])
  end

  # POST /default_aliases
  # POST /default_aliases.xml
  def create
    @default_alias = @account.default_aliases.new(params[:default_alias])

    respond_to do |format|
      if @default_alias.save
        flash[:notice] = t('default_aliases.create.notice')
        format.html { redirect_to(default_aliases_path) }
        format.xml  { render :xml => @default_alias, :status => :created, :location => @default_alias }
      else
        flash[:alert] = t('default_aliases.create.alert')
        format.html { render :action => "new" }
        format.xml  { render :xml => @default_alias.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /default_aliases/1
  # PUT /default_aliases/1.xml
  def update
    @default_alias = @account.default_aliases.get!(params[:id])

    respond_to do |format|
      if @default_alias.update(params[:default_alias])
        flash[:notice] = t('default_aliases.update.notice')
        format.html { redirect_to(default_aliases_path) }
        format.xml  { head :ok }
      else
        flash[:alert] = t('default_aliases.update.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @default_alias.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /default_aliases/1
  # DELETE /default_aliases/1.xml
  def destroy
    @default_alias = @account.default_aliases.get!(params[:id])
    if @default_alias.system
      flash[:alert] = t('default_aliases.destroy.alert')
      return redirect_to(default_aliases_url)
    end
    @default_alias.destroy

    respond_to do |format|
      flash[:notice] = t('default_aliases.destroy.notice')
      format.html { redirect_to(default_aliases_url) }
      format.js
      format.xml  { head :ok }
    end
  end

  def set_active
    @default_alias = @account.default_aliases.get!(params[:id])

    respond_to do |format|
      if @default_alias.update(:active => true)
        flash[:notice] = t('default_aliases.set_active.notice')
        format.html { redirect_to(default_aliases_path) }
        format.js { render 'active_toggle' }
        format.xml  { head :ok }
      else
        flash[:alert] = t('default_aliases.set_active.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @default_alias.errors, :status => :unprocessable_entity }
      end
    end
  end

  def set_inactive
    @default_alias = @account.default_aliases.get!(params[:id])

    respond_to do |format|
      if @default_alias.update(:active => false)
        flash[:notice] = t('default_aliases.set_inactive.notice')
        format.html { redirect_to(default_aliases_path) }
        format.js { render 'active_toggle' }
        format.xml  { head :ok }
      else
        flash[:alert] = t('default_aliases.set_inactive.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @default_alias.errors, :status => :unprocessable_entity }
      end
    end
  end
end
