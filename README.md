
# GIF finder using Texture + RxSwift 🎏

<p float="left">
  <img src="/Assets/preview-1.png" width="300" height="auto" hspace="50"/>
  <img src="/Assets/preview-2.png" width="300" height="auto" hspace="50"/>
</p>

Learning the implementation of [Texture](https://github.com/TextureGroup/Texture) framework to build asynchronous UI and also reactive programming using [RxSwift](https://github.com/ReactiveX/RxSwift). This app demonstrates how we can build smooth and responsive UIs and also reacting to any state changes by building a GIF finder app. This app was inspired by my previous similar GIF app using `Operation` in Swift. Go check it out! ([link to the repo](https://github.com/vctxr/swift-async-operation))

> **Note:** I'm currently still learning about these frameworks so the implementation of these frameworks are based on my personal learning on the topic 📖. Oh and this app also fetches GIF from the Giphy API which requires an API key 🔑 which I kept secret, so please use your own API key instead WKWK.

# 🤖 Demo

<p float="left">
  <img src="/Assets/demo-1.gif" width="300" height="auto" hspace="50"/>
  <img src="/Assets/demo-2.gif" width="300" height="auto" hspace="50"/>
</p>

# 🦄 Highlights

- Smooth and asynchronous UI built using Texture
- Reactive programming using RxSwift
- Custom `Pinterest` style layout
- Infinite scrolling to fetch more GIFs
- Search GIF with debouncing to save API calls