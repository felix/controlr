class DomainsController < ApplicationController
  authorize_resource :class => 'Domain'

  # GET /domains
  # GET /domains.xml
  def index
    @domains = @account.domains.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @domains }
    end
  end

  # GET /domains/1
  # GET /domains/1.xml
  def show
    @domain = @account.domains.get(params[:id])
    session[:current_domain_id] = @domain.id if @domain

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @domain }
    end
  end

  # GET /domains/new
  # GET /domains/new.xml
  def new
    @domain = @account.domains.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @domain }
    end
  end

  # GET /domains/1/edit
  def edit
    @domain = @account.domains.get(params[:id])
    redirect_to domains_path unless @domain
  end

  # POST /domains
  # POST /domains.xml
  def create
    @domain = @account.domains.new(params[:domain])

    respond_to do |format|
      if @domain.save && create_default_aliases(@domain)
        format.html { redirect_to(domains_path, :notice => 'Domain was successfully created.') }
        format.xml  { render :xml => @domain, :status => :created, :location => @domain }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @domain.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /domains/1
  # PUT /domains/1.xml
  def update
    @domain = @account.domains.get(params[:id])
    redirect_to domains_path unless @domain

    respond_to do |format|
      if @domain.update(params[:domain])
        format.html { redirect_to(domains_path, :notice => 'Domain was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @domain.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /domains/1
  # DELETE /domains/1.xml
  def destroy
    @domain = @account.domains.get(params[:id])
    @domain.destroy if @domain

    respond_to do |format|
      format.html { redirect_to(domains_url) }
      format.xml  { head :ok }
    end
  end

  def switch
    session[:current_domain_id] = params[:id] if params[:id]
    redirect_to(request.referrer)
  end

  private

  def create_default_aliases(domain)
    # TODO get default from settings
    hostmaster = domain.aliases.new(
      :source => "hostmaster@#{domain.name}",
      :destination => 'hostmaster@seconddrawer.com.au',
      :active => true,
      :system => true
    )
    postmaster = domain.aliases.new(
      :source => "postmaster@#{domain.name}",
      :destination => 'postmaster@seconddrawer.com.au',
      :active => true,
      :system => true
    )
    catchall = domain.aliases.new(
      :source => "@#{domain.name}",
      :destination => '',
      :active => false,
      :system => true
    )
    domain.save
  end
end
