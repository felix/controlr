class AliasesController < ApplicationController
  authorize_resource
  append_before_filter do
    redirect_to domains_url unless @domain
  end

  rescue_from DataMapper::ObjectNotFoundError do |exception|
    redirect_to aliases_path, :alert => t('missing')
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
        format.html { redirect_to(aliases_path, :notice => 'Alias address was successfully created.') }
        format.xml  { render :xml => @alias, :status => :created, :location => @alias }
      else
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
        format.html { redirect_to(aliases_path, :notice => 'Alias address was successfully updated.') }
        format.xml  { head :ok }
      else
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
      return redirect_to(aliases_url, :alert => 'Cannot delete this alias')
    end
    @alias.destroy

    respond_to do |format|
      format.html { redirect_to(aliases_url) }
      format.js
      format.xml  { head :ok }
    end
  end

  def set_active
    @alias = @domain.aliases.get!(params[:id])

    respond_to do |format|
      if @alias.update(:active => true)
        format.html { redirect_to(aliases_path) }
        format.js { render 'active_toggle' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @alias.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def set_inactive
    @alias = @domain.aliases.get!(params[:id])

    respond_to do |format|
      if @alias.update(:active => false)
        format.html { redirect_to(aliases_path) }
        format.js { render 'active_toggle' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @alias.errors, :status => :unprocessable_entity }
      end
    end
  end
end
