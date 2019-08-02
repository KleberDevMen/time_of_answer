# frozen_string_literal: true

class AdminsBackoffice::QuestionsController < AdminsBackofficeController
  before_action :set_question, only: [:edit, :update, :destroy]
  before_action :set_subjects, only: [:edit, :new]

  def index
    @questions = Question.includes(:subject)
                     .order(updated_at: :desc)
                     .page(params[:page])
  end

  def edit; end

  def update
    if @question.update(params_question)
      redirect_to admins_backoffice_questions_path, notice: 'Pergunta atualizado com sucesso!'
    else
      render :edit
    end
  end

  # atiSistemas123!@#
  def new
    @question = Question.new
  end

  def create
    @question = Question.new(params_question)
    if @question.save
      redirect_to admins_backoffice_questions_path, notice: 'Pergunta cadastrado com sucesso!'
    else
      render :new
    end
  end

  def destroy
    if @question.destroy
      redirect_to admins_backoffice_questions_path, notice: 'Pergunta excluído com sucesso!'
    else
      render :index
    end
  end

  private

  def set_subjects
    @subjects = Subject.order(:description)
  end

  def params_question
    params.require(:question).permit(:description, :subject_id)
  end

  def set_question
    @question = Question.find params[:id]
  end

end
