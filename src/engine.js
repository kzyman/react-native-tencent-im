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
     * @param {string} name - 监听的名字 目前只支持 joinChannelSuccess, joinChannelError groupMessage onMemberEnter onMemberInfoChanged
     * @param {function} callback - 回调函数
     * @param {bool} onlyCurrentRoom - 是否只接受当前房间的信息 默认true
     * @param {bool} igonreSelf - 忽略自己的消息 默认trye
     */
    addListener(name, callback, onlyCurrentRoom = true, igonreSelf = true) {
        RtcEngineEvent.addListener(name, e => {
            // 过滤掉自己的消息
            if (name === 'groupMessage') {
                if (igonreSelf && this.userId && `${this.userId}` === `${e.sender}`) {
                    return;
                }
                if (onlyCurrentRoom && this.classId && this.classId !== e.groupId) {
                    return;
                }
            }
            callback(e);
        });
    }
    removeListener(name, callback) {
        RtcEngineEvent.removeListener(name, callback);
    }
    /**
     * 移除所有的监听事件
     */
    async removeAllListeners() {
        const keys = ['joinChannelSuccess', 'joinChannelError', 'groupMessage', 'onMemberEnter', 'onMemberInfoChanged'];
        for (const key of keys) {
            RtcEngineEvent.removeAllListeners(key);
        }
    }
    /**
     * 释放白板引擎
     */

    async unInitEngine() {
        const keys = ['joinChannelSuccess', 'joinChannelError', 'groupMessage'];
        for (const key of keys) {
            RtcEngineEvent.removeAllListeners(key);
        }
    }
    /**
     * 腾讯IM
     * @param {number} sdkAppid -sdkAppid
     */
    async initEngine(sdkAppid) {
        await IMEngineManager.initEngine(sdkAppid);
    }
    /**
     * 获取群组的成员列表信息
     * @param {string} classId - 频道的名称
     * @param {function} callback -发送的信息
     */
    async getGroupMemberList(classId, callback) {
        if (!callback) {
            callback = () => {};
        }
        await IMEngineManager.getGroupMemberList(classId, callback);
    }
    /**
     * 退出Im
     */
    async logout() {
        await IMEngineManager.logout();
    }
    /**
     * 设置个人信息
     * @param {string} nickName - nickName
     */
    async setSelfInfo(nickName) {
        await IMEngineManager.setSelfInfo(nickName);
    }
    /**
     * 加入频道
     * @param {string} classId - 班级的id
     * @param {string} userId - 用户的id
     * @param {string} userName - 用户的昵称
     * @param {string} userSig - 用户的签名
     */
    async joinChannel(classId, userId, userName,userSig) {
        this.classId = classId;
        this.userId = userId;
        await IMEngineManager.joinChannel(classId, userId, userName, userSig);
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
     * @param {function} callback -发送的信息
     */
    async sendMessage(message, callback) {
        if (!callback) {
            callback = () => {};
        }
        await IMEngineManager.sendMessage(message, callback);
    }
}
export default new IMEngine();
