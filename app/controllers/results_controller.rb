class ResultsController < ApplicationController
  allow_unauthenticated_access only: :index

  before_action :set_result, only: %i[ show edit update destroy ]

  def index
    @results = Result.ordered
    @statistics = Result.statistics
  end

  def show
  end

  def new
    @result = Result.new
  end

  def edit
  end

  def create
    @result = Result.new(result_params)

    if @result.save
      redirect_to @result, notice: "Result was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @result.update(result_params)
      redirect_to @result, notice: "Result was successfully updated.", status: :see_other
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
      params.expect(result: [ :number, :score, :position, :comment ])
    end
end
