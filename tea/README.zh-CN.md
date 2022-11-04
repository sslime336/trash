# tea

[English](README.md) | 简体中文

---

TEA(微型加密算法)的纯 Nim 实现

## 什么是 TEA

TEA 算法由剑桥大学计算机实验室的 David Wheeler 和 Roger Needham 于1994年发明。
它是一种分组密码算法，其明文密文块为64比特，密钥长度为128比特。
TEA算法利用不断增加的 Delta (黄金分割率)值作为变化，使得每轮的加密是不同，
该加密算法的迭代次数可以改变，建议的迭代次数为32轮

**百度百科** <https://baike.baidu.com/item/TEA%E5%8A%A0%E5%AF%86%E7%AE%97%E6%B3%95/9383067>

**维基百科** <https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm>

## 关于

简单集成了 TEA 相关算法的实现，并提供相对简洁地 API

## 更多有关 TEA 算法的内容

[**XTEA**](https://en.wikipedia.org/wiki/XTEA) - TEA 算法的第一个升级版

[**XXTEA(CBTEA)**](https://en.wikipedia.org/wiki/XXTEA) - 又称 Corrected Block TEA, XTEA 的升级版

## 生成文档

在项目根目录运行 `nim doc tea.nim` 即可
