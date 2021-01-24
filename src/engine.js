import React from 'react';
import { NativeModules, NativeEventEmitter } from 'react-native';

const IMEngineManager = NativeModules.IMEngineManager;
const RtcEngineEvent = new NativeEventEmitter(IMEngineManager);
class IMEngine {
    constructor() {
        this.classId = null;
        this.userId = null;
    }
    /**
     * 监听函数
     * @param {string} name - 监听的名字 目前只支持 joinChannelSuccess, joinChannelError groupMessage
     * @param {function} callback - 回调函数
     * @param {bool} onlyCurrentRoom - 是否只接受当前房间的信息
     * @param {bool} igonreSelf - 忽略自己的消息
     */
    addListener(name, callback, onlyCurrentRoom, igonreSelf) {
        RtcEngineEvent.addListener(name, e => {
            // 过滤掉自己的消息
            console.log(this.classId, e.groupId, '收到的笑嘻嘻嘻嘻嘻', e, this.userId, 'uuuuuse');
            if (igonreSelf && this.userId && `${this.userId}` === `${e.sender}`) {
                return;
            }
            if (onlyCurrentRoom && this.classId && this.classId !== e.groupId) {
                return;
            }
            callback(e);
        });
    }
    removeListener(name, callback) {
        RtcEngineEvent.removeListener(name, callback);
    }
    /**
     * 释放白板引擎
     */
    async unInitEngine() {
        const keys = ['joinChannelSuccess', 'joinChannelError', 'groupMessage'];
        for (const key of keys) {
            RtcEngineEvent.removeAllListeners(key);
        }
        await IMEngineManager.unInitEngine();
    }
    /**
     * 腾讯IM
     * @param {number} sdkAppid -sdkAppid
     */
    async initEngine(sdkAppid) {
        await IMEngineManager.initEngine(sdkAppid);
    }
    /**
     * 加入频道
     * @param {string} classId - 班级的id
     * @param {string} userId - 用户的id
     * @param {string} userSig - 用户的签名
     */
    async joinChannel(classId, userId, userSig) {
        this.classId = classId;
        this.userId = userId;
        await IMEngineManager.joinChannel(classId, userId, userSig);
    }
    /**
     * 退出频道
     */
    async leaveChannel() {
        await IMEngineManager.leaveChannel();
    }
    /**
     *
     * @param {string} message -发送的信息
     */
    async sendMessage(message) {
        await IMEngineManager.sendMessage(message);
    }
}
export default new IMEngine();
