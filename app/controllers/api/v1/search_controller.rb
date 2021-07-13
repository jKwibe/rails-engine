class Api::V1::SearchController < ApplicationController
  def find_merchant
    if params[:name] && params[:name].present?
      merchant = Merchant.find_match_by_name(params[:name]).first

      if merchant
        render json: MerchantSerializer.new(merchant)
      else
        blank_merchant = Merchant.create
        render json: MerchantSerializer.new(blank_merchant), status: :bad_request
      end
    else
      render json: { error: 'Please include name param' }.to_json, status: :bad_request
    end
  end

  def find_items
    if params[:name]&.present?
      items = Item.find_match_by_name(params[:name])
      render json: ItemSerializer.new(items) if items
    else
      render json: { error: 'Please include name param' }.to_json, status: :bad_request
    end
  end
end
