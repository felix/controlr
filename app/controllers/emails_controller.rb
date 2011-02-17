class EmailesController < ApplicationController
  # GET /emailes
  # GET /emailes.xml
  def index
    @emailes = Email.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @emailes }
    end
  end

  # GET /emailes/1
  # GET /emailes/1.xml
  def show
    @email = Email.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @email }
    end
  end

  # GET /emailes/new
  # GET /emailes/new.xml
  def new
    @email = Email.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @email }
    end
  end

  # GET /emailes/1/edit
  def edit
    @email = Email.find(params[:id])
  end

  # POST /emailes
  # POST /emailes.xml
  def create
    @email = Email.new(params[:email])

    respond_to do |format|
      if @email.save
        format.html { redirect_to(@email, :notice => 'Email address was successfully created.') }
        format.xml  { render :xml => @email, :status => :created, :location => @email }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @email.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /emailes/1
  # PUT /emailes/1.xml
  def update
    @email = Email.find(params[:id])

    respond_to do |format|
      if @email.update_attributes(params[:email])
        format.html { redirect_to(@email, :notice => 'Email address was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @email.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /emailes/1
  # DELETE /emailes/1.xml
  def destroy
    @email = Email.find(params[:id])
    @email.destroy

    respond_to do |format|
      format.html { redirect_to(emailes_url) }
      format.xml  { head :ok }
    end
  end
end
