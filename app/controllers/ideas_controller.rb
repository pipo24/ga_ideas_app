class IdeasController < ApplicationController
  before_action :set_idea, only: [:show, :edit, :update, :destroy]
  # respond_to :html, :json

  # GET /ideas 
  # GET /ideas.json
  def index
    @q = Idea.ransack(params[:q])
    @search_field = :title_cont
    if params[:q].present?
      @ideas = @q.result(distinct: true)
    else
      @ideas = Idea.all
    end
    # respond_with @ideas
    respond_to do |format|
      format.html
      format.json { render json: @ideas }
    end
  end

  # GET /ideas/1
  # GET /ideas/1.json
  def show
    @comments = @idea.comments

  end


  def get_payment
    @idea = Idea.find(params[:id])
    Stripe.api_key = ENV["STRIPE_API_KEY"]

    # Get the credit card details submitted by the form
    token = params[:stripeToken]

    # Create the customer on Stripe's servers
    customer = Stripe::Customer.create(
      :source => token,
      :description => "Example customer"
      )

    # ***** NOT WORKING IN HAML FOR SOME REASON! Was working before merging and changing to haml *****
    # Create the charge on Stripe's servers - this will charge the user's card
    # Stripe::Charge.create(
    #         :amount => 1000, # in cents
    #         :currency => "gbp",
    #         :customer => customer.id,
    #         :description => "Endorsed Idea on GA-Network"
    #         )

    # **** USED TO SAVE CUSTOMER AND ADD TO DATABASE AS CUSTOMER_ID ****
    # # Save the customer ID in your database so you can use it later
    # save_stripe_customer_id(@user, customer.id)

    # # Later...
    # customer_id = get_stripe_customer_id(@user)

    #   Stripe::Charge.create(
    #     :amount   => 1500, # £15.00 this time
    #     :currency => "gbp",
    #     :customer => customer_id
    #     )

    # redirect to idea show page
    redirect_to @idea, notice: "Payment has been executed"
  end

  # GET /ideas/new
  def new
    @idea = Idea.new
  end

  # GET /ideas/1/edit
  def edit
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea = current_user.ideas.new(idea_params)

    respond_to do |format|
      if @idea.save
        format.html { redirect_to @idea, notice: 'Idea was successfully created.' }
        format.json { render :show, status: :created, location: @idea }
      else
        format.html { render :new }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ideas/1
  # PATCH/PUT /ideas/1.json
  def update
    respond_to do |format|
      if @idea.update(idea_params)
        format.html { redirect_to @idea, notice: 'Idea was successfully updated.' }
        format.json { render :show, status: :ok, location: @idea }
      else
        format.html { render :edit }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea.destroy
    respond_to do |format|
      format.html { redirect_to ideas_url, notice: 'Idea was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @idea = Idea.find(params[:id])
    @idea.liked_by current_user
    redirect_to @idea
  end

  def downvote
    @idea = Idea.find(params[:id])
    @idea.disliked_by current_user
    redirect_to @idea
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_idea
      @idea = Idea.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def idea_params
      params.require(:idea).permit(:user_id, :title, :genre, :brief, :description)
    end 
  end


