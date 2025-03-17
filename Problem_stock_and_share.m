symbol = "AAPL";
startDate = "2023-01-01";
endDate = "2023-12-31";

% แปลงวันที่เป็น UNIX Timestamp
startUnix = posixtime(datetime(startDate, 'InputFormat', 'yyyy-MM-dd'));
endUnix = posixtime(datetime(endDate, 'InputFormat', 'yyyy-MM-dd'));

% สร้าง URL ดึงข้อมูลหุ้นจาก Yahoo Finance
url = "https://query1.finance.yahoo.com/v7/finance/download/" + symbol + ...
    "?period1=" + num2str(startUnix) + "&period2=" + num2str(endUnix) + ...
    "&interval=1d&events=history";

% โหลดข้อมูลเข้า MATLAB
data = webread(url);

% แปลงเป็นตาราง
stockData = readtable(url);

% แสดงตัวอย่างข้อมูล
disp(stockData(1:5, :))
