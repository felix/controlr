class MailboxesController < ApplicationController
  authorize_resource
  append_before_filter do
    redirect_to(domains_url, :notice => 'Please select a domain first') unless @domain
  end

  rescue_from DataMapper::ObjectNotFoundError do |exception|
    redirect_to mailboxes_path, :alert => t('missing')
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
        format.html { redirect_to(mailboxes_path, :notice => 'Mailbox address was successfully created.') }
        format.xml  { render :xml => @mailbox, :status => :created, :location => @mailbox }
      else
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
        format.html { redirect_to(mailboxes_path, :notice => 'Mailbox address was successfully updated.') }
        format.xml  { head :ok }
      else
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
      format.html { redirect_to(mailboxes_url) }
      format.xml  { head :ok }
    end
  end

end
