class DefaultNameRecordsController < ApplicationController
  authorize_resource

  rescue_from DataMapper::ObjectNotFoundError do |exception|
    redirect_to default_name_records_path, :alert => t('.missing')
  end

  # GET /default_name_records
  # GET /default_name_records.xml
  def index
    @default_name_records = @account.default_name_records.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @default_name_records }
    end
  end

  # GET /default_name_records/1
  # GET /default_name_records/1.xml
  def show
    @default_name_record = @account.default_name_records.get!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @default_name_record }
    end
  end

  # GET /default_name_records/new
  # GET /default_name_records/new.xml
  def new
    @default_name_record = @account.default_name_records.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @default_name_record }
    end
  end

  # GET /default_name_records/1/edit
  def edit
    @default_name_record = @account.default_name_records.get!(params[:id])
  end

  # POST /default_name_records
  # POST /default_name_records.xml
  def create
    @default_name_record = @account.default_name_records.new(params[:default_name_record])

    respond_to do |format|
      if @default_name_record.save
        flash[:notice] = t('default_name_records.create.notice')
        format.html { redirect_to(default_name_records_path) }
        format.xml  { render :xml => @default_name_record, :status => :created, :location => @default_name_record }
      else
        flash[:alert] = t('default_name_records.create.alert')
        format.html { render :action => "new" }
        format.xml  { render :xml => @default_name_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /default_name_records/1
  # PUT /default_name_records/1.xml
  def update
    @default_name_record = @account.default_name_records.get!(params[:id])

    respond_to do |format|
      if @default_name_record.update(params[:default_name_record])
        flash[:notice] = t('default_name_records.update.notice')
        format.html { redirect_to(default_name_records_path) }
        format.xml  { head :ok }
      else
        flash[:alert] = t('default_name_records.update.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @default_name_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  def set_active
    @default_name_record = @account.default_name_records.get!(params[:id])

    respond_to do |format|
      if @default_name_record.update(:active => true)
        flash[:notice] = t('default_name_records.set_active.notice')
        format.html { redirect_to(default_name_records_path) }
        format.js { render 'active_toggle', :layout => 'application' }
        format.xml  { head :ok }
      else
        flash[:alert] = t('default_name_records.set_active.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @default_name_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  def set_inactive
    @default_name_record = @account.default_name_records.get!(params[:id])

    respond_to do |format|
      if @default_name_record.update(:active => false)
        flash[:notice] = t('default_name_records.set_inactive.notice')
        format.html { redirect_to(default_name_records_path) }
        format.js { render 'active_toggle' }
        format.xml  { head :ok }
      else
        flash[:alert] = t('default_name_records.set_inactive.alert')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @default_name_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /default_name_records/1
  # DELETE /default_name_records/1.xml
  def destroy
    @default_name_record = @account.default_name_records.get!(params[:id])
    @default_name_record.destroy

    respond_to do |format|
      flash[:notice] = t('default_name_records.destroy.notice')
      format.html { redirect_to(default_name_records_url) }
      format.js
      format.xml  { head :ok }
    end
  end
end
