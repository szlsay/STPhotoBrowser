# STPhotoBrowser
高仿新浪微博的图片浏览器，极佳的编写方式，易扩展，低耦合，欢迎大家使用

### 新浪微博的原始效果，2016-01-10的版本
![image](https://github.com/STShenZhaoliang/STPhotoBrowser/blob/master/Picture/sinaImage.gif)
### 1.添加显示和隐藏动画，左右滑动显示图片
![image](https://github.com/STShenZhaoliang/STPhotoBrowser/blob/master/Picture/show1.gif)
### 2.添加手势操作，单击隐藏图片浏览器，双击放大和还原，双指放大和缩小
![image](https://github.com/STShenZhaoliang/STPhotoBrowser/blob/master/Picture/show2.gif)
### 3.添加保存效果，高仿新浪微博保存动画
![image](https://github.com/STShenZhaoliang/STPhotoBrowser/blob/master/Picture/show3.gif)
### 4.预加载图片，若没有加载成功，现在重载按钮
![image](https://github.com/STShenZhaoliang/STPhotoBrowser/blob/master/Picture/show4.gif)
### 5.支持横竖屏
![image](https://github.com/STShenZhaoliang/STPhotoBrowser/blob/master/Picture/show5.gif)

### 6.在UITableView的案例(UICollectionView的案例可依据它来编写)
![image](https://github.com/STShenZhaoliang/STPhotoBrowser/blob/master/Picture/show7.gif)
### 7.点击保存按钮事件中存在的问题及解决方法
![image](https://github.com/STShenZhaoliang/STPhotoBrowser/blob/master/Picture/show6.gif)
#### 问题1.当点击保存按钮之后，执行保存的操作和提示动画效果，此时按钮是不可以点击的，但实际情况是可以点击的
#### 解决方法：使用RAC，当点击保存按钮之后，按钮不可使用，在动画完成后，按钮可以使用（或是显示“已保存”，按钮不可使用）
#### 问题2.没有下载下来的图片是不可有保存到本地操作的，在代码中可以使用 “isLoadedImage”属性可查看是否已经下载下来，但是首次载入的时候，并没有及时获取“isLoadedImage”属性，使得按钮是可以点击的
#### 解决方法：使用RAC，开始的时候保存按钮是不可使用的（为红色，我设的红色）,但下载完成后，发送消息改变按钮的状态。
