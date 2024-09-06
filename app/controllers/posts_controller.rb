class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy download]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def download
    post_pdf = @post.generate_post_pdf
    # post_pdf = Prawn::Document.new
    # #for header we will use #bounding box method for shifting the coordinate space and serves two purposes first it provide bound for flowing text starting at any given points and it translates the origin 0 0 to graphic primitives
    # #and for bounding box there r various arguments must be provided as mandatory arguments height is optional ,if you don't provide height to it will become stretchy and calculated automatically as you stretch
    # #the box downward means depending upon the content we are showing into the header
    # # post_pdf.bounding_box([post_pdf.bounds.left,post_pdf.bounds.top],width: post_pdf.bounds.width) do
    # #   post_pdf.text 'Blogging App',size: 40,style: :bold, align: :center

    # #   #stroke method to draw horizontal line is stroke horizontal rule 
    # #   post_pdf.stroke_horizontal_rule
    # # end

    # #when we want header in every page
    # post_pdf.repeat(:all) do
    #   post_pdf.bounding_box([post_pdf.bounds.left,post_pdf.bounds.top],width: post_pdf.bounds.width) do
    #     post_pdf.text 'Blogging App',size: 40,style: :bold, align: :center
    #     post_pdf.stroke_horizontal_rule
    #   end

    #   post_pdf.bounding_box([post_pdf.bounds.left,post_pdf.bounds.bottom + 30],width: post_pdf.bounds.width) do
    #     post_pdf.stroke_horizontal_rule
    #     post_pdf.move_down 5
    #     post_pdf.text 'Blogging App Footer',size: 20,style: :bold, align: :center
    #   end
    #   # post_pdf.move_down 30
    # end

    # post_pdf.bounding_box([post_pdf.bounds.left,post_pdf.bounds.top - 60 ],width: post_pdf.bounds.width,height: post_pdf.bounds.height - 100) do
    #   # post_pdf.move_down -10
    #   post_pdf.text @post.title,size: 30,style: :bold,align: :center
    #   #we can add or display image into prawn pdf like watermark,static and dynamic image associate with records below is example of static
    #   # post_pdf.image "#{Rails.root}/app/assets/images/Unique-Blog-Ideas.png",at:[30,600],width: 500 #rails.root will find project directory name

    #   #for dynamic image display we use to upload active storage attachment
    #   #rails active_storage:install,rails db:migrate
    #   post_pdf.image StringIO.open(@post.cover_image.download),at:[30,600],width: 500 
    #   post_pdf.move_down 200
    #   post_pdf.text @post.description
    # end

    # # post_pdf.bounding_box([post_pdf.bounds.left,post_pdf.cursor],width: post_pdf.bounds.width,height: post_pdf.cursor) do
    # #   post_pdf.text @post.title,size: 30,style: :bold,align: :center
    # #   #we can add or display image into prawn pdf like watermark,static and dynamic image associate with records below is example of static
    # #   # post_pdf.image "#{Rails.root}/app/assets/images/Unique-Blog-Ideas.png",at:[30,600],width: 500 #rails.root will find project directory name

    # #   #for dynamic image display we use to upload active storage attachment
    # #   #rails active_storage:install,rails db:migrate
    # #   post_pdf.image StringIO.open(@post.cover_image.download),at:[30,600],width: 500 
    # #   post_pdf.move_down 500
    # #   post_pdf.text @post.description
    # # end

    # #move down method to separate title from line by 30 pixel
    # # post_pdf.move_down 30
    # post_pdf.font('Times-Roman') do #helvetica is default family
    # end
    # # post_pdf.text @post.title,size: 30,style: :bold,align: :center
    # # post_pdf.text @post.description
    if params[:preview].present?
      send_data(post_pdf.render,filename:"#{@post.title}.pdf",type: 'application/pdf',disposition:'inline')
    else
      send_data(post_pdf.render,filename:"#{@post.title}.pdf",type: 'application/pdf')
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :description,:cover_image)
    end
end




#there are various way to make controller thin like handling logics inside the model methods,active support concerns,scopes,service classes and lib classes and so on














