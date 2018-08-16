install.packages("httr")
install.packages("rvest")
library(httr)
library(rvest)
Sys.setlocale("LC_ALL", "Korean")

client_id = '7YkOVDACRTf5wRfPu0TB';
client_secret = 'GXrSBy_IWi';
header = httr::add_headers(
  'X-Naver-Client-ID' = client_id,
  'X-Naver-Client-Secret' = client_secret
)

query = '허니버터칩'
# encoding 변화
query = iconv(query, to = 'UTF-8', toRaw = T)
# iconv(query, to = 'UTF-8', toRaw = F)
query= paste0('%', paste(unlist(query), collapse = '%'))
query = toupper(query)

query

# make URL
end_num = 1000
display_num = 100
start_point = seq(1, end_num, by = display_num)
i = 1
url = paste0('https://openapi.naver.com/v1/search/blog.xml?query=',query,'&display=',display_num,'&start=',
             start_point[i], '&sort=sim')
url_body = read_xml(GET(url, header))

title = url_body %>% xml_nodes('item title') %>%
  xml_text()

final_dat = NULL
for(i in 1:length(start_point))
{
  # request xml format
  url = paste0('https://openapi.naver.com/v1/search/blog.xml?query',query,'&display=',display_num,'&start=',
               start_point[i], '&sort=sim')
  # open header
  url_body = read_xml(GET(url, header), encoding = "UTF-8")
  title = url_body %>% xml_nodes('item title') %>% xml_text()
  bloggername = url_body %>% xml_nodes('item bloggername') %>% xml_text()
  postdate = url_body %>% xml_nodes('postdate') %>% xml_text()
  link = url_body %>% xml_nodes('item link') %>% xml_text()
  description = url_body %>% xml_nodes('item description') %>% xml_text()
  temp_dat = cbind(title, bloggername, postdate, link, description)
  final_dat = rbind(final_dat, temp_dat)
  cat(i, '\n')
}
final_dat = data.frame(final_dat, stringsAsFactors = F)
