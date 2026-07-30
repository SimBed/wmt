class ResultsController < ApplicationController
  allow_unauthenticated_access only: :index

  before_action :set_result, only: %i[ edit update destroy ]

  def index
  @results =
    if params[:full_team].present?
             Result.order_by_number.where(full_team: true)
    else
             Result.order_by_number
    end
    @statistics = Result.statistics(@results)
  end

  def new
    @result = Result.new
    @next_number = Result.next_number
  end

  def edit
  end

  def create
    @result = Result.new(result_params)

    if @result.save
      redirect_to results_path, notice: "Result was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @result.update(result_params)
      redirect_to results_path, notice: "Result was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @result.destroy!
    redirect_to results_path, notice: "Result was successfully destroyed.", status: :see_other
  end

  private
    def set_result
      @result = Result.find(params.expect(:id))
    end

    def result_params
      params.expect(result: [ :number, :score, :position, :full_team, :comment ])
    end
end
