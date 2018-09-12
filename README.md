퍼펙트 루비 온 레일즈 4장 View
=============================

#### 연습준비
<br>
**1. git 실행**
<pre>$ git init</pre>

**2. git clone**
<pre>$ git clone https://github.com/shkim5164/perfect_ror_4.git </pre>

**3. 마이그레이션 적용**
<pre>$ rake db:migrate</pre>

**4. Run project**

-------------------------------------------------------

- 일단 일반적인 입력양식을 index.html에 생성해 두었다.
~~~html
  <form action = '/home/create' method = 'post' class = 'form'>
      <p>제목</p>
      <input type = 'text' name = 'title' value = '' placeholder ='제목' class = 'title'>
      <p>내용</p>
      <textarea name = 'content' value = '' placeholder ='내용' class = 'content'></textarea>
      <p>라디오버튼</p>
      <input type="radio" name="gender" value="male" checked> Male<br>
      <input type="radio" name="gender" value="female"> Female<br>
      <input type="radio" name="gender" value="other"> Other
      <p>체크박스</p>
      <input type="checkbox" name="vehicle" value="1" checked> 1<br>
      <input type="checkbox" name="vehicle" value="2"> 2<br>
      <input type = 'submit' value = '제출'>
  </form>
~~~

- 위 내용을 레일즈 form 헬퍼로 똑같이 작성해 보고, 차이점을 알아보자.

## 4-1. 입력 양식 생성
- 우리는 지금까지 html form 태그를 사용하여 입력양식을 생성하였다.
- 레일즈 프로젝트에서 post 방식에서 보안에 취약한 점이 드러나기도 하면서 레일즈 프로젝트에서는 별로 좋지 않다는 것을 알았다.
- 그래서 레일즈 프로젝트에서 제공하는 form 헬퍼를 이용하여 만들어보자.
- 레일즈에는 html form태그와 같은 기능을 하는 form 헬퍼를 3개 가지고 있다.

### 4.1.1 form_tag
- 이 헬퍼는 범용적인 form 양식을 생성할 때 사용한다.

<pre>
   form_tag({A}, [B]) do
    ..다른 입력 양식..
   end
   ---------------------------------------------------
   A : html form 태그에 action에 해당되는 부분
   B : 밑에 표 참고</pre>

- B에서 쓸 수 있는 옵션

|     옵션     |                                       설명                                       |
|:------------:|:--------------------------------------------------------------------------------:|
|    method    | 입력양식을 전송할 방식 (html form 태그에서의 method와 같음, 기본적으로 post 방식 |
|   multipart  |         enctype 속성에 "multipart/form-data"를 설정할지 여부(파일 업로드)        |
| id, class 등 |                        html form 태그에서 쓰던 기타 옵션들                       |


- form_tag의 A부분은 html form 태그의 action에 해당되는 부분으로서 다음과 같이 작성한다.
<br>
<br>
ex) home 컨트롤러의 create 액션으로 넘어갈경우

~~~html
<!-- 기존의 html form -->
<form action = '/home/create'>
</form>
<!-- form_tag -->
<%= form_tag({controller: :home, action: :create}) do %>
<% end %>
~~~
- form_tag에서는 url_for 부분의 방식을 적용하는데 지금은 이정도로만 알아둔다.

-  그리고 B 부분에 method 와 html에서 적용할수있는 다른 속성을 지정할 수 있다.

~~~html
<!-- 기존의 html form -->
<form action = '/home/create' method = 'post' class = 'form'>
</form>
<!-- form_tag -->
<%= form_tag({controller: :home, action: :create}, method: 'post', class: 'form') %>
<% end %>
~~~

### 4.1.2 form_tag에서 사용하는 input 태그

- 앞에서 말했다시피 form_tag는 범용적인 양식을 생성한다.
- form_tag에서 쓰는 input 헬퍼들도 범용적인 녀석들을 사용하여야 한다.
- 이 녀석들은 뒤에 "tag" 가 붙는다.
- 위의 예시로 주어진 종류는 크게 4가지 이다.

#### 4.1.2.1 text_area_tag
~~~ruby
<%= text_area_tag [name부분], [value부분], [그외 다른 속성], ... %>
~~~

- html로 말하면 textarea 태그이다.
- 예시로서 비교해보자.

~~~html

<textarea name = 'content' value = '' placeholder ='내용' class = 'content'></textarea>

<%= text_area_tag :content, "", placeholder: '내용', class: 'content' %>
~~~

- 위 두 내용은 완전 같은 것이다.
- 다만 html의 경우 필요없는 속성은 완전히 제외해도 되지만, text_area_tag의 경우 두번째 속성을 반드시 value로 인식한다. 그렇기 때문에 아무 내용을 적고 싶지 않으면, "" 로 빈공간을 만들어준다.

#### 4.1.2.2 radio_button_tag
~~~ruby
<%= radio_button_tag [name부분], [value부분], [check여부], [그외html속성], ... %>
~~~
- 여러 선택지 중 하나만 선택할 수 있는 라디오 버튼 헬퍼이다.
- 라디오 버튼은 기본적으로 name에 사용자가 선택한 value가 담겨 params값으로 넘어간다.
- 고로 name은 같지만 value가 모두 다르다. 예시를 보자.

~~~html
<input type="radio" name="gender" value="male" checked> Male<br>
<input type="radio" name="gender" value="female"> Female<br>
<input type="radio" name="gender" value="other"> Other
----------------------------------------------------------------------------
<lable><%= radio_button_tag :gender, "male", true %>Male</lable><br>
<lable><%= radio_button_tag :gender, "female", false %>Female</lable><br>
<lable><%= radio_button_tag :gender, "other", false %>Other</lable><br>
~~~

- html 태그는 라디오 버튼 뒤에 선택지에 대한 설명을 바로 적어주면 화면에 뜨지만,
- radio tag 헬퍼는 label 태그를 이용하여 적어주어야 한다.

#### 4.1.2.3 check_box_tag

~~~ruby
<%= check_box_tag [name부분], [value부분], [check여부], [그외html속성], ... %>
~~~

- check_box_tag 또한 radio_button_tag 와 비슷하다.
- 바로 예시를 보자.

~~~html
<input type="checkbox" name="vehicle" value="1" checked> 1<br>
<input type="checkbox" name="vehicle" value="2"> 2<br>
----------------------------------------------------------------------
<lable><%= check_box_tag :vehicle, "1", true %>1</lable><br>
<lable><%= check_box_tag :vehicle, "2", false %>2</lable>
~~~

- name부분은 radio나 checkbox나 모두 심볼 속성으로 작성한다.

#### 4.1.2.4 xxxxx_field_tag
~~~ruby
<%= xxxxx_field_tag [name부분], [value부분], [그외 html 속성], ... %>
~~~

- 위에서 설명한 3가지 태그를 제외하고는 html에서 사용하는 input 종류들을 이 태그로 사용가능하다.
- xxxxx에 들어갈 속성은 아래 링크를 참조하자.
<http://api.rubyonrails.org/v5.1/classes/ActionView/Helpers/FormTagHelper.html>
<http://guides.rorlab.org/form_helpers.html>

예시)
~~~html
<input type = 'text' name = 'title' value = '' placeholder ='제목' class = 'title'>
-----------------------------------------------------------------------------------------
 <%= text_field_tag(:title, "", placeholder: '제목', class: 'title') %>
~~~

### 4.2.1 모델에 연결된 form_tag

- 모델과 연결된 form 헬퍼는 두가지가 있는데,
- 그 중 하나를 먼저 알아보자.
- 현재 아래와 같은 속성을 가진 Post 모델이 이미 생성되어 있다.

~~~ruby
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.integer :checkbox
      t.string :radio

      t.timestamps null: false
    end
  end
end
~~~

- 이 form 헬퍼는 모델과 연결되어있어, 사용되는 방식이 조금 다르다.
- 먼저 컨트롤러에 새 Post 레코드를 선언해주어야 한다.

~~~ruby
def index
    @post = Post.new
end
~~~

- 이제 양식을 살펴보자.

~~~html
<%= form_tag({action: :create}, method: 'post', class: 'form') do%>
      <p>내용</p>
      <%= text_field :post, :title, placeholder: '제목', class: 'title' %>
      <p>내용</p>
      <%= text_area :post, :content, placeholder: '내용', class: 'content' %>
      <p>라디오버튼</p>
      <lable><%= radio_button :post, :radio, 'male' %>Male</lable><br>
      <lable><%= radio_button :post, :radio, 'female' %>Female</lable><br>
      <lable><%= radio_button :post, :radio, 'other' %>Other</lable><br>
      <p>체크박스</p>
      <lable><%= check_box :post, :checkbox, {},'no', '1' %>1</lable><br>
      <lable><%= check_box :post, :checkbox, {}, 'no', '2' %>2</lable><br>
      <%= submit_tag("제출") %>
<% end %>
~~~

- 위는 모델을 직접적으로 편집하는 form태그로 짜인 것이다.
- 우리가 처음에 살펴본 범용적인 form_tag와 무엇이 다른지 살펴보자.

~~~
<%= form_tag({controller: :home, action: :create}, method: 'post', class: 'form') %>
-----------------------------------------------------------------------------------------
<%= form_tag({action: :create}, method: 'post', class: 'form') do%>
~~~
- 먼저, form 헬퍼에서 컨트롤러를 생략할 수 있게 되었다. 그 외에는 같다.

~~~html
<p>제목</p>
    <%= text_field_tag(:title, "", placeholder: '제목', class: 'title') %>
<p>내용</p>
    <%= text_area_tag :content, "", placeholder: '내용', class: 'content' %>
<p>라디오버튼</p>
    <lable><%= radio_button_tag :gender, "male", true %>Male</lable><br>
    <lable><%= radio_button_tag :gender, "female", false %>Female</lable><br>
    <lable><%= radio_button_tag :gender, "other", false %>Other</lable><br>
<p>체크박스</p>
    <lable><%= check_box_tag :vehicle, "1", true %>1</lable><br>
    <lable><%= check_box_tag :vehicle, "2", false %>2</lable><br>
------------------------------------------------------------------------------
<p>제목</p>
    <%= text_field :post, :title, placeholder: '제목', class: 'title' %>
<p>내용</p>
    <%= text_area :post, :content, placeholder: '내용', class: 'content' %>
<p>라디오버튼</p>
    <lable><%= radio_button :post, :radio, 'male' %>Male</lable><br>
    <lable><%= radio_button :post, :radio, 'female' %>Female</lable><br>
    <lable><%= radio_button :post, :radio, 'other' %>Other</lable><br>
<p>체크박스</p>
    <lable><%= check_box :post, :checkbox, {},'no', '1' %>1</lable><br>
    <lable><%= check_box :post, :checkbox, {}, 'no', '2' %>2</lable><br>
~~~

- 일단 헬퍼에 붙던 "tag"가 사라졌다.
- 그리고 모든 뷰 헬퍼의 첫번째 속성이 @post를 불러오는 것으로 바뀌었다.
- 즉   
~~~
<%= text_area [@post를 :post로 불러옴], [name속성], ... %>
~~~
- 방식으로 바뀌었다. 살펴보면 모든 헬퍼 첫 속성이 :post임을 알 수 있다.
- 뒤의 name속성도 모델이 입력한 이름을 적어준다.
- 그리고 check_box 속성에서도

~~~
<%= check_box_tag [name속성], [value속성], [check여부], ... %>
-----------------------------------------------------------------------------------------------------------------------
<%= check_box [@post불러오기], [name속성], {[그외html속성,..]}, [체크를 했을때의 value], [체크를 안했을 때의 value] %>
~~~

- 로 바뀌었는데,
- 예시를 보자.

~~~
  <lable><%= check_box :post, :checkbox, {},'no', '1' %>1</lable><br>
~~~

- @post에 checkbox 속성에 저장이 되고, 체크를 하고 submit 했을 시 'no'라는 값을,
- 체크를 안했을 시 1이라는 값을 담아 보내준다.

- 그리고 여기서 데이터 값은 원래 params[:name] 으로 넘어오던것이
- 우리가 만든 post의 해쉬의 key와 value값으로 넘어온다.
- 즉,
~~~ruby
post : {
  title: 'title1'
  content: 'content'
  radio: 'Male'
  checkbox: '1'
}
# => post[:title] 이런식으로 불러오면 됨.
~~~
- 위의 방식으로 전달된다.
- 나중엔 이 방식이 그대로 update에 적용이 되어 코드 낭비를 줄여준다.

### 4.2.3 모델을 직접 편집하는 f.form_tag

- 위의 모델 편집방식은 각 헬퍼마다 모델객체(:post)를 입력해줘야 한다는 불편함이 있었다.
- f.Form 헬퍼는 이 불편함을 해소한다.
- 마치 반복문처럼 모델의 속성을 변수에 담아 반복한다.

~~~html
<%= form_for(@post, url: {controller: 'home', action: 'create'}, html: {method: 'post', class: 'form'}) do |f| %>
      <p>제목</p>
      <%= f.text_field :title, placeholder: '제목', class: 'title' %>
      <p>내용</p>
      <%= f.text_area :content, placeholder: '내용', class: 'content' %>
      <p>라디오버튼</p>
      <lable><%= f.radio_button :radio, 'male' %>Male</lable><br>
      <lable><%= f.radio_button :radio, 'female' %>Female</lable><br>
      <lable><%= f.radio_button :radio, 'other' %>Other</lable><br>
      <p>체크박스</p>
      <lable><%= f.check_box :checkbox, {},'no', '1' %>1</lable><br>
      <lable><%= f.check_box :checkbox, {}, 'no', '2' %>2</lable><br>
      <%= submit_tag("제출") %>
<% end %>
~~~

- 위 양식은 f.From 헬퍼로 똑같이 만든 양식이다.
- 바로 앞에서 소개한 모델편집 form_tag보다 간소화 되었고,
- 편리한 기능 또한 다 가지고 있다.
- 다만

~~~ruby
<%= form_for(
[controller에서 선언한 새 모델레코드(여기서는 @post)],
url: {[컨트롤러랑 액션]},
html: {html 속성}
) do |f| %>
~~~

- form 태그에서 컨트롤러와 액션, html속성을 { }에 묶어줘야한다는 불편함이 생겼고 do 뒤에 반복할 변수를 선언해주어야 한다.
- 예시

~~~ruby
<%= form_for(
@post,
url: {controller: 'home', action: 'create'},
html: {method: 'post', class: 'form'}
) do |f| %>
...
<% end %>
~~~
