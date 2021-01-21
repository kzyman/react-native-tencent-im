import React from 'react';
import { NativeModules, NativeEventEmitter } from 'react-native';

const IMEngineManager = NativeModules.IMEngineManager;
const RtcEngineEvent = new NativeEventEmitter(IMEngineManager);
class IMEngine {
    constructor() {}
    /**
     * 监听函数
     * @param {string} name - 监听的名字 目前只支持 JoinChannelSuccess, JoinChannelError groupMessage
     * @param {function} callback - 回调函数
     */
    addListener(name, callback) {
        RtcEngineEvent.addListener(name, e => {
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
        const keys = ['JoinChannelSuccess', 'JoinChannelError', 'groupMessage'];
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
