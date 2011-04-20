class DomainsController < ApplicationController
  authorize_resource :except => :switch

  rescue_from DataMapper::ObjectNotFoundError do |exception|
    redirect_to(domains_path, :alert => t('domains.missing'))
  end

  # GET /domains
  # GET /domains.xml
  def index
    if can? :manage, Domain
      @domains = @account.domains.all
    else
      @domains = current_user.domains
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @domains }
    end
  end

  # GET /domains/1
  # GET /domains/1.xml
  def show
    @domain = @account.domains.get!(params[:id])
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
    @domain = @account.domains.get!(params[:id])
    session[:current_domain_id] = @domain.id if @domain
  end

  # POST /domains
  # POST /domains.xml
  def create
    @domain = @account.domains.new(params[:domain])

    respond_to do |format|
      if @domain.save
        flash[:notice] = t('domains.create.notice')
        format.html { redirect_to(domain_path(@domain)) }
        format.xml  { render :xml => @domain, :status => :created, :location => @domain }
      else
        flash[:alert] = t('domains.create.alert')
        format.html { render :action => "new" }
        format.xml  { render :xml => @domain.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /domains/1
  # PUT /domains/1.xml
  def update
    @domain = @account.domains.get!(params[:id])

    respond_to do |format|
      if @domain.update(params[:domain])
        flash[:notice] = t('domains.update.notice')
        format.html { redirect_to(domain_path(@domain)) }
        format.xml  { head :ok }
      else
        flash[:alert] = t('domains.update.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @domain.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /domains/1
  # DELETE /domains/1.xml
  def destroy
    @domain = @account.domains.get!(params[:id])
    @domain.destroy

    respond_to do |format|
      flash[:notice] = t('domains.destroy.notice')
      format.html { redirect_to(domains_url) }
      format.xml  { head :ok }
    end
  end

  def switch
    if params[:id].empty?
      flash[:alert] = t('domains.switch.alert')
      redirect_to root_path
    else
      session[:current_domain_id] = params[:id]
      flash[:notice] = t('domains.switch.notice')
      if @domain
        redirect_back_or_default(domain_path(session[:current_domain_id]))
      else
        redirect_to(domain_path(session[:current_domain_id]))
      end
    end
  end

  def sync
    @domain = @account.domains.get!(params[:id])

    @domain.sync_config_files

    respond_to do |format|
      flash[:notice] = t('domains.sync.notice')
      format.html { redirect_to(domain_path(@domain)) }
      format.xml  { head :ok }
    end
  end

end
