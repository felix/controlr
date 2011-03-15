class AliasesController < ApplicationController
  before_filter :get_domain, :authenticate_user!
  authorize_resource :class => 'Email'

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
    @alias = Alias.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @alias }
    end
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
    @alias = Alias.get(params[:id])
  end

  # POST /aliases
  # POST /aliases.xml
  def create
    @alias = @domain.aliases.new(params[:alias])

    respond_to do |format|
      if @alias.save
        format.html { redirect_to([@domain,@alias], :notice => 'Alias address was successfully created.') }
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
    @alias = @domain.aliases.get(params[:id])

    respond_to do |format|
      if @alias.update(params[:alias])
        format.html { redirect_to([@alias.domain,@alias], :notice => 'Alias address was successfully updated.') }
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
    @alias = @domain.aliases.get(params[:id])
    @alias.destroy

    respond_to do |format|
      format.html { redirect_to(aliases_url) }
      format.xml  { head :ok }
    end
  end

  private

  def get_domain
    @domain = Domain.get!(params[:domain_id])
  rescue DataMapper::ObjectNotFoundError
    redirect_to :root
  end
end
