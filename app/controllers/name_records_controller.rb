class NameRecordsController < ApplicationController
  # GET /name_records
  # GET /name_records.xml
  def index
    @name_records = NameRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @name_records }
    end
  end

  # GET /name_records/1
  # GET /name_records/1.xml
  def show
    @name_record = NameRecord.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @name_record }
    end
  end

  # GET /name_records/new
  # GET /name_records/new.xml
  def new
    @name_record = NameRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @name_record }
    end
  end

  # GET /name_records/1/edit
  def edit
    @name_record = NameRecord.get(params[:id])
  end

  # POST /name_records
  # POST /name_records.xml
  def create
    @name_record = NameRecord.new(params[:name_record])

    respond_to do |format|
      if @name_record.save
        format.html { redirect_to(@name_record, :notice => 'Name record was successfully created.') }
        format.xml  { render :xml => @name_record, :status => :created, :location => @name_record }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @name_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /name_records/1
  # PUT /name_records/1.xml
  def update
    @name_record = NameRecord.get(params[:id])

    respond_to do |format|
      if @name_record.update(params[:name_record])
        format.html { redirect_to(@name_record, :notice => 'Name record was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @name_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /name_records/1
  # DELETE /name_records/1.xml
  def destroy
    @name_record = NameRecord.get(params[:id])
    @name_record.destroy

    respond_to do |format|
      format.html { redirect_to(name_records_url) }
      format.xml  { head :ok }
    end
  end
end
