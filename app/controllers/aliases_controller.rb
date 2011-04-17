class AliasesController < ApplicationController
  authorize_resource
  append_before_filter do
    redirect_to(domains_url, :alert => t('aliases.domain_missing')) unless @domain
  end

  rescue_from DataMapper::ObjectNotFoundError do |exception|
    redirect_to aliases_path, :alert => t('aliases.missing')
  end

  # GET /aliases
  # GET /aliases.xml
  def index
    @aliases = @domain.aliases.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @aliases }
    end
  end

  # GET /aliases/1
  # GET /aliases/1.xml
  def show
    redirect_to edit_alias_path(params[:id])
  end

  # GET /aliases/new
  # GET /aliases/new.xml
  def new
    @alias = @domain.aliases.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @alias }
    end
  end

  # GET /aliases/1/edit
  def edit
    @alias = @domain.aliases.get!(params[:id])
  end

  # POST /aliases
  # POST /aliases.xml
  def create
    @alias = @domain.aliases.new(params[:alias])

    respond_to do |format|
      if @alias.save
        flash[:notice] = t('aliases.create.notice')
        format.html { redirect_to(aliases_path) }
        format.xml  { render :xml => @alias, :status => :created, :location => @alias }
      else
        flash[:alert] = t('aliases.create.alert')
        format.html { render :action => "new" }
        format.xml  { render :xml => @alias.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /aliases/1
  # PUT /aliases/1.xml
  def update
    @alias = @domain.aliases.get!(params[:id])

    respond_to do |format|
      if @alias.update(params[:alias])
        flash[:notice] = t('aliases.update.notice')
        format.html { redirect_to(aliases_path) }
        format.xml  { head :ok }
      else
        flash[:alert] = t('aliases.update.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @alias.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /aliases/1
  # DELETE /aliases/1.xml
  def destroy
    @alias = @domain.aliases.get!(params[:id])
    if @alias.system
      flash[:alert] = t('aliases.destroy.alert')
      return redirect_to(aliases_url)
    end
    @alias.destroy

    respond_to do |format|
      flash[:notice] = t('aliases.destroy.notice')
      format.html { redirect_to(aliases_url) }
      format.js
      format.xml  { head :ok }
    end
  end

  def set_active
    @alias = @domain.aliases.get!(params[:id])

    respond_to do |format|
      if @alias.update(:active => true)
        flash[:notice] = t('aliases.set_active.notice')
        format.html { redirect_to(aliases_path) }
        format.js { render 'active_toggle' }
        format.xml  { head :ok }
      else
        flash[:alert] = t('aliases.set_active.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @alias.errors, :status => :unprocessable_entity }
      end
    end
  end

  def set_inactive
    @alias = @domain.aliases.get!(params[:id])

    respond_to do |format|
      if @alias.update(:active => false)
        flash[:notice] = t('aliases.set_inactive.notice')
        format.html { redirect_to(aliases_path) }
        format.js { render 'active_toggle' }
        format.xml  { head :ok }
      else
        flash[:alert] = t('aliases.set_inactive.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @alias.errors, :status => :unprocessable_entity }
      end
    end
  end
end
