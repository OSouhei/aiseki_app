# 年・月・日・何時何分まで同じか？
RSpec::Matchers.define :be_same_date_time do |expected|
  match do |actual|
    date_reg = /\d{4}-\d{1,2}-\d{1,2}/
    time_reg = /\d{1,2}:\d{1,2}:/ # 分まで同じならOK
    # 日付が違う場合はfalseを返す
    return false unless expected.to_s.match(date_reg)[0] == actual.to_s.match(date_reg)[0]

    # 時間が同じ場合はtrueを返す
    expected.to_s.match(time_reg)[0] == actual.to_s.match(time_reg)[0]
  end
end
