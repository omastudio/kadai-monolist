class ItemsController < ApplicationController
  
  before_action :require_user_logged_in
  
  def new
    #空の配列として初期化
    @items = []

    #フォームから送信される検索ワードを取得
    @keyword = params[:keyword]
    if @keyword.present?
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })

      results.each do |result|
        # 扱い易いように Item としてインスタンスを作成する（保存はしない）
        item = Item.new(read(result))
        @items << item
      end
    end
  end
  
  private

  def read(result)
    code = result['itemCode']
    name = result['itemName']
    url = result['itemUrl']
    image_url = result['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')
    
    #必要な値を読み出して、最後にハッシュとしてreturn

    {
      code: code,
      name: name,
      url: url,
      image_url: image_url,
    }
  end
end
