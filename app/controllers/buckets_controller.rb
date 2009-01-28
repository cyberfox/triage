class BucketsController < ApplicationController
  # GET /buckets
  # GET /buckets.xml
  def index
    @buckets = Bucket.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @buckets }
    end
  end

  # GET /buckets/1
  # GET /buckets/1.xml
  def show
    @bucket = Bucket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bucket }
    end
  end

  # GET /buckets/new
  # GET /buckets/new.xml
  def new
    prep_bucket_form

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bucket }
    end
  end

  # GET /buckets/1/edit
  def edit
    @bucket = Bucket.find(params[:id])
    @milestone = @bucket.milestone
    prep_bucket_form
  end

  # POST /buckets
  # POST /buckets.xml
  def create
    modified = extract_bucket_params

    @bucket = current_user.buckets.find(modified[:id]) unless modified[:id].blank?
    @bucket = current_user.buckets.new(modified) if @bucket.nil?

    new_record = @bucket.new_record?

    if request.xhr?
      render_bucket_xml(new_record) if @bucket.save
    else
      respond_to do |format|
        if @bucket.save
          flash[:notice] = 'Bucket was successfully created.'
          format.html { redirect_to(@bucket) }
          format.xml  { render_bucket_xml(new_record) }
        else
          format.html do
            prep_bucket_form
            render :action => "new"
          end
          format.xml  { render :xml => @bucket.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /buckets/1
  # PUT /buckets/1.xml
  def update
    @bucket = Bucket.find(params[:id])

    modified = extract_bucket_params

    respond_to do |format|
      if @bucket.update_attributes(modified)
        flash[:notice] = 'Bucket was successfully updated.'
        format.html { redirect_to(@bucket) }
        format.xml  { head :ok }
      else
        format.html do
          prep_bucket_form
          render :action => "edit"
        end
        format.xml  { render :xml => @bucket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /buckets/1
  # DELETE /buckets/1.xml
  def destroy
    @bucket = Bucket.find(params[:id])
    @bucket.destroy

    respond_to do |format|
      format.html { redirect_to(buckets_url) }
      format.xml  { head :ok }
    end
  end

  private
  def extract_bucket_params
    modified = params[:bucket]
    if modified
      modified[:milestone_id] = nil if modified[:milestone_id].blank?
      modified[:state] = nil        if modified[:state].blank?
    else
      modified = {}
    end
    return modified
  end

  def render_bucket_xml(new_record)
    render :xml => @bucket, :status => (new_record ? :created : :ok), :location => @bucket 
  end
end
