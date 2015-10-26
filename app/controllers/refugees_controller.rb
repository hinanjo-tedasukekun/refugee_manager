class RefugeesController < ApplicationController
  def count
    @num_of_refugees = Family.sum(:num_of_members)
  end

  def input_barcode_num
  end

  def query
    barcode = RefugeeManager::BarCode.new(params[:refugee_num])
    unless barcode.valid?
      raise 'Invalid barcode'
    end

    refugee = Refugee.find_by(id: barcode.refugee_id)
    if refugee
      redirect_to action: 'edit', id: refugee.id
    else
      redirect_to action: 'new', refugee_num: params[:refugee_num]
    end
  end

  def new
  end

  def create
  end

  def edit
    @refugee = Refugee.find(params[:id])
  end

  def index
    redirect_to root_path
  end
end
