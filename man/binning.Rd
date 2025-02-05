% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/binning.R
\name{binning}
\alias{binning}
\title{수치 데이터의 비닝}
\usage{
binning(
  x,
  nbins,
  type = c("quantile", "equal", "pretty", "kmeans", "bclust"),
  ordered = TRUE,
  labels = NULL,
  approxy.lab = TRUE
)
}
\arguments{
\item{x}{numeric. 비닝의 대상이 되는 수치 벡터}

\item{nbins}{integer. 비닝할 빈(bin)의 개수. 필수 인수로 만약에 기술하지
않으면 nclass.Sturges의 결과가 사용됩니다.}

\item{type}{character. 비닝 방법을 기술합니다. "quantile", "equal", "pretty",
"kmeans", "bclust"에서 선택합니다.
"quantile"는 동일한 분위수 구간의 브레이크포인트를 사용하여 비닝합니다.
"equal"은 동일한 길이의 구간(interval)의 브레이크포인트를 사용하여 비닝합니다.
"pretty"는 base::pretty() 함수를 활용하여 비닝합니다.
"kmeans"는 stats::kmeans() 함수를 사용하여 k-mean 방법으로 비닝합니다.
"bclust"는 e1071::bclust() 함수를 사용하여 bagged clustering 방법으로 비닝합니다.
"kmeans"와 "bclust" 방법은 classInt::classIntervals() 함수를 사용하였습니다.}

\item{ordered}{logical. 비닝된 결과를 ordered factor로 생성할지의 여부}

\item{labels}{character. 각 수준에 사용할 라벨 이름}

\item{approxy.lab}{logical. 큰 숫자의 프레이크포인트에 대해서 근사값의,
좀더 예쁜 값의 라벨을 취할지의 여부를 선택합니다. TRUE일 경우에는 근사값으로,
FALSE일 경우에는 원래의 값을 라벨로 사용합니다.}
}
\value{
bins 클래스 객체.
bins 클래스의 속성은 다음과 같습니다.
\itemize{
\item class : "bins"
\item type : 비닝 방법, "quantile", "equal", "pretty", "kmeans", "bclust".
\item breaks : 수치 벡터가 절단된 구간의 브레이크 포인트
\item levels : 비닝된 범주형 데이터의 수준
\item raw : 비닝 되기 전의 원(raw) 데이터로서의 수치 벡터
}
}
\description{
binning()은 수치형 데이터를 비닝하여 범주형 데이터로 변환합니다.
}
\details{
이 함수는 dplyr 패키지의  mutate, 혹은 transmute 함수와 사용하면
효율적으로 데이터를 비닝할 수 있습니다.

비닝의 이해를 위해서 vignette("transformation") 명령어로 비네트를 참고 하세요.
}
\examples{
# <ec>삁<ec>젣瑜<bc> <ec>쐞<ed>븳 <eb>뜲<ec>씠<ed>꽣 <ec>깮<ec>꽦
heartfailure2 <- heartfailure
heartfailure2[sample(seq(NROW(heartfailure2)), 20), "platelets"] <- NA

# type <ec>씤<ec>닔<ec>쓽 湲곕낯媛믪씤 "quantile"<ec>쓣 <ec>씠<ec>슜<ed>븳 platelets 蹂<ec>닔<ec>쓽 鍮꾨떇
bin <- binning(heartfailure2$platelets)

# bins <ed>겢<eb>옒<ec>뒪 媛앹껜<ec>쓽 異쒕젰
bin

# bins <ed>겢<eb>옒<ec>뒪 媛앹껜<ec>쓽 <ec>슂<ec>빟
summary(bin)

# Plot bins class object
plot(bin)

# labels <ec>씤<ec>닔瑜<bc> <ec>씠<ec>슜<ed>븳 <ec>궗濡
bin <- binning(heartfailure2$platelets, nbins = 4,
              labels = c("LQ1", "UQ1", "LQ3", "UQ3"))
bin

# <eb>떎瑜<b8> <ec>씤<ec>닔瑜<bc> <ec>씠<ec>슜<ed>븳 <ec>궗濡<eb>뱾
bin <- binning(heartfailure2$platelets, nbins = 5, type = "equal")
bin
bin <- binning(heartfailure2$platelets, nbins = 5, type = "pretty")
bin
bin <- binning(heartfailure2$platelets, nbins = 5, type = "kmeans")
bin
bin <- binning(heartfailure2$platelets, nbins = 5, type = "bclust")
bin

x <- sample(1:1000, size = 50) * 12345679
bin <- binning(x)
bin
bin <- binning(x, approxy.lab = FALSE)
bin

# 鍮꾨떇<eb>맂 寃곌낵<ec>쓽 異붿텧
extract(bin)

# ------------------------------------
# dplyr <ed>뙣<ed>궎吏<ec><99> <ed>뙆<ec>씠<ed>봽瑜<bc> <ec>씠<ec>슜<ed>븳 <ec>궗濡
# ------------------------------------
library(dplyr)

# 鍮꾨떇<eb>맂 寃곌낵瑜<bc> death_event 蹂<ec>닔蹂꾨줈 <eb>룛<ec>닔瑜<bc> 援ы븿
heartfailure2 \%>\%
 mutate(platelets_bin = binning(heartfailure2$platelets) \%>\%
          extract()) \%>\%
 group_by(death_event, platelets_bin) \%>\%
 summarise(freq = n()) \%>\%
 arrange(desc(freq)) \%>\%
 head(10)

 # 鍮꾨떇<eb>맂 寃곌낵瑜<bc> death_event 蹂<ec>닔蹂꾨줈 <eb>룛<ec>닔 <ed>뙆<ec>븙<ed>븷 <ec>닔 <ec>엳<eb>뒗 <ec>떆媛곹솕
 heartfailure2 \%>\%
   mutate(platelets_bin = binning(heartfailure2$platelets) \%>\%
            extract()) \%>\%
   target_by(death_event) \%>\%
   relate(platelets_bin) \%>\%
   plot()

}
\seealso{
\code{\link{binning_by}}, \code{\link{print.bins}},
\code{\link{summary.bins}}, \code{\link{plot.bins}}.
}
