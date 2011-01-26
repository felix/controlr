class DomainRecordsController < ApplicationController
  # GET /domain_records
  # GET /domain_records.xml
  def index
    @domain_records = DomainRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @domain_records }
    end
  end

  # GET /domain_records/1
  # GET /domain_records/1.xml
  def show
    @domain_record = DomainRecord.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @domain_record }
    end
  end

  # GET /domain_records/new
  # GET /domain_records/new.xml
  def new
    @domain_record = DomainRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @domain_record }
    end
  end

  # GET /domain_records/1/edit
  def edit
    @domain_record = DomainRecord.get(params[:id])
  end

  # POST /domain_records
  # POST /domain_records.xml
  def create
    @domain_record = DomainRecord.new(params[:domain_record])

    respond_to do |format|
      if @domain_record.save
        format.html { redirect_to(@domain_record, :notice => 'Domain record was successfully created.') }
        format.xml  { render :xml => @domain_record, :status => :created, :location => @domain_record }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @domain_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /domain_records/1
  # PUT /domain_records/1.xml
  def update
    @domain_record = DomainRecord.get(params[:id])

    respond_to do |format|
      if @domain_record.update(params[:domain_record])
        format.html { redirect_to(@domain_record, :notice => 'Domain record was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @domain_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /domain_records/1
  # DELETE /domain_records/1.xml
  def destroy
    @domain_record = DomainRecord.get(params[:id])
    @domain_record.destroy

    respond_to do |format|
      format.html { redirect_to(domain_records_url) }
      format.xml  { head :ok }
    end
  end
end
