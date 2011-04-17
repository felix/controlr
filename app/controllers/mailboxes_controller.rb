class MailboxesController < ApplicationController
  authorize_resource
  append_before_filter do
    redirect_to(domains_url, :alert => t('mailboxes.domain_missing')) unless @domain
  end

  rescue_from DataMapper::ObjectNotFoundError do |exception|
    redirect_to mailboxes_path, :alert => t('mailboxes.missing')
  end

  # GET /mailboxes
  # GET /mailboxes.xml
  def index
    @mailboxes = @domain.mailboxes.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mailboxes }
    end
  end

  # GET /mailboxes/1
  # GET /mailboxes/1.xml
  def show
    redirect_to edit_mailbox_path(params[:id])
  end

  # GET /mailboxes/new
  # GET /mailboxes/new.xml
  def new
    @mailbox = @domain.mailboxes.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mailbox }
    end
  end

  # GET /mailboxes/1/edit
  def edit
    @mailbox = @domain.mailboxes.get!(params[:id])
  end

  # POST /mailboxes
  # POST /mailboxes.xml
  def create
    @mailbox = @domain.mailboxes.new(params[:mailbox])

    respond_to do |format|
      if @mailbox.save
        flash[:notice] = t('mailboxes.create.notice')
        format.html { redirect_to(mailboxes_path) }
        format.xml  { render :xml => @mailbox, :status => :created, :location => @mailbox }
      else
        flash[:alert] = t('mailboxes.create.alert')
        format.html { render :action => "new" }
        format.xml  { render :xml => @mailbox.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mailboxes/1
  # PUT /mailboxes/1.xml
  def update
    @mailbox = @domain.mailboxes.get!(params[:id])
    params[:mailbox].delete(:passhash) unless params[:mailbox][:passhash].blank?

    respond_to do |format|
      if @mailbox.update(params[:mailbox])
        flash[:notice] = t('mailboxes.update.notice')
        format.html { redirect_to(mailboxes_path) }
        format.xml  { head :ok }
      else
        flash[:alert] = t('mailboxes.update.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mailbox.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mailboxes/1
  # DELETE /mailboxes/1.xml
  def destroy
    @mailbox = @domain.mailboxes.get!(params[:id])
    @mailbox.destroy

    respond_to do |format|
      flash[:notice] = t('mailboxes.destroy.notice')
      format.html { redirect_to(mailboxes_url) }
      format.js
      format.xml  { head :ok }
    end
  end

  def set_active
    @mailbox = @domain.mailboxes.get!(params[:id])

    respond_to do |format|
      if @mailbox.update(:active => true)
        flash[:notice] = t('mailboxes.set_active.notice')
        format.html { redirect_to(mailboxes_path) }
        format.js { render 'active_toggle' }
        format.xml  { head :ok }
      else
        flash[:alert] = t('mailboxes.set_active.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mailbox.errors, :status => :unprocessable_entity }
      end
    end
  end

  def set_inactive
    @mailbox = @domain.mailboxes.get!(params[:id])

    respond_to do |format|
      if @mailbox.update(:active => false)
        flash[:notice] = t('mailboxes.set_inactive.notice')
        format.html { redirect_to(mailboxes_path) }
        format.js { render 'active_toggle' }
        format.xml  { head :ok }
      else
        flash[:alert] = t('mailboxes.set_inactive.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mailbox.errors, :status => :unprocessable_entity }
      end
    end
  end

end
