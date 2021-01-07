import React from 'react';
import { NativeModules, NativeEventEmitter } from 'react-native';

const TICBridgeManager = NativeModules.TICBridgeManager;
const RtcEngineEvent = new NativeEventEmitter(TICBridgeManager);
class TxEducationEngine {
    constructor() {}
    /**
     * 监听函数
     * @param {string} name - 监听的名字 目前只支持 BorderviewReady, JoinChannelSuccess, JoinChannelError
     * @param {function} callback - 回调函数
     */
    addListener(name, callback) {
        RtcEngineEvent.addListener(name, e => {
            callback(e);
        });
    }
    /**
     * 方法集合器
     * @param {string} name - 函数名称
     * @param {object} params - 参数的字典
     */
    async callMethod(name, params) {
        return await TICBridgeManager.callMethod(name, params);
    }
    /**
     * 解散群组,只有群主可以操作
     */
    async dismissGroup() {
        await TICBridgeManager.dismissGroup();
    }
    /**
     * 释放白板引擎
     */
    async unInitEngine() {
        await TICBridgeManager.unInitEngine();
    }
    /**
     * 初始化白板引擎包括 腾讯IM
     * @param {string} sdkAppid -sdkAppid
     */
    async initEngine(sdkAppid) {
        await TICBridgeManager.initEngine(sdkAppid);
    }
    /**
     * 加入频道
     * @param {string} classId - 班级的id
     * @param {string} userId - 用户的id
     * @param {string} userSig - 用户的签名
     */
    async joinChannel(classId, userId, userSig) {
        await TICBridgeManager.joinChannel(classId, userId, userSig);
    }
    /**
     * 设置白板工具
     *  TEDU_BOARD_TOOL_TYPE_MOUSE              = 0,    ///< 鼠标
     *  TEDU_BOARD_TOOL_TYPE_PEN                = 1,    ///< 画笔
     *  TEDU_BOARD_TOOL_TYPE_ERASER             = 2,    ///< 橡皮擦
     *  TEDU_BOARD_TOOL_TYPE_LASER              = 3,    ///< 激光笔
     *  TEDU_BOARD_TOOL_TYPE_LINE               = 4,    ///< 直线
     *  TEDU_BOARD_TOOL_TYPE_OVAL               = 5,    ///< 空心椭圆
     *  TEDU_BOARD_TOOL_TYPE_RECT               = 6,    ///< 空心矩形
     *  TEDU_BOARD_TOOL_TYPE_OVAL_SOLID         = 7,    ///< 实心椭圆
     *  TEDU_BOARD_TOOL_TYPE_RECT_SOLID         = 8,    ///< 实心矩形
     *  TEDU_BOARD_TOOL_TYPE_POINT_SELECT       = 9,    ///< 点选工具
     *  TEDU_BOARD_TOOL_TYPE_RECT_SELECT        = 10,   ///< 选框工具
     *  TEDU_BOARD_TOOL_TYPE_TEXT               = 11,   ///< 文本工具
     *  TEDU_BOARD_TOOL_TYPE_ZOOM_DRAG          = 12,   ///< 缩放移动
     *  TEDU_BOARD_TOOL_TYPE_SQUARE             = 13,   ///<空心正方形
     *  TEDU_BOARD_TOOL_TYPE_SQUARE_SOLID       = 14,   ///<实心正方形
     *  TEDU_BOARD_TOOL_TYPE_CIRCLE             = 15,   ///<空心正圆形
     *  TEDU_BOARD_TOOL_TYPE_CIRCLE_SOLID       = 16,   ///<实心正圆形
     *  TEDU_BOARD_TOOL_TYPE_BOARD_CUSTOM_GRAPH = 17,   ///<自定义图形，请配合addElement(TEDU_BOARD_ELEMENT_CUSTOM_GRAPH, '自定义图形URL')接口使用
     * @param {number} type
     */
    async setToolType(type) {
        return await TICBridgeManager.callMethod('setToolType', { type });
    }
    /**
     * 清空当前白板页涂鸦
     * @param {boolean} background - 是否同时清空背景色以及背景图片
     * @param {boolean} selected - 是否只清除选中部分涂鸦
     * @warning 目前不支持清除选中部分的同时清除背景
     */
    async clearBackground(background, selected) {
        return await TICBridgeManager.callMethod('clearBackground', {
            background,
            selected,
        });
    }
    /**
     * 设置刷子颜色
     * @param {string} color - 只支持rgba
     */
    async setBrushColor(color) {
        a.replace('rgba(', '')
            .replace(')', '')
            .split(',')
            .map(() => {
                return parseFloat(i);
            });
        return await TICBridgeManager.callMethod('setBrushColor', { color });
    }
    /**
     * 设置刷子的粗细
     * @param {number} thin - 画笔的粗细
     */
    async setBrushThin(thin) {
        return await TICBridgeManager.callMethod('setBrushThin', { thin });
    }
    /**
     * 设置文本的颜色
     * @param {string} color - 只支持rgba
     */
    async setTextColor(color) {
        a.replace('rgba(', '')
            .replace(')', '')
            .split(',')
            .map(() => {
                return parseFloat(i);
            });
        return await TICBridgeManager.callMethod('setTextColor', { color });
    }
    /**
     * 设置文本的大小
     * @param {number} size - 文字的大小 float int 都可以.
     */
    async setTextSize(size) {
        return await TICBridgeManager.callMethod('setTextSize', { size });
    }
    /**
     * 撤销操作
     */
    async undo() {
        return await TICBridgeManager.callMethod('undo');
    }
    /**
     * 重做操作
     */
    async redo() {
        return await TICBridgeManager.callMethod('redo');
    }
    /**
     * 添加元素,图片, H5网页元素
     * @param {string} url - 网页或者图片的 url，只支持 https 协议的网址或者图片 url
     * @param {number} type - 元素类型，当设置 TEDU_BOARD_ELEMENT_IMAGE 时，等价于 addImageElement 方法
     * @warning
     * （1）当 type = TEDU_BOARD_ELEMENT_IMAGE，支持 png、jpg、gif、svg 格式的本地和网络图片，当 url 是一个有效的本地文件地址时，该文件会被自动上传到 COS，上传进度回调 onTEBFileUploadStatus
     * （2）当 type = TEDU_BOARD_ELEMENT_CUSTOM_GRAPH，仅支持网络 url，请与自定义图形工具 TEDU_BOARD_TOOL_TYPE_BOARD_CUSTOM_GRAPH 配合使用
     */
    async addElement(url, type) {
        return await TICBridgeManager.callMethod('addElement', { url, type });
    }
    /**
     * 是否允许涂鸦
     * @param {boolean} enable - 是否允许涂鸦，true 表示白板可以涂鸦，false 表示白板不能涂鸦
     *
     */
    async setDrawEnable(enable) {
        return await TICBridgeManager.callMethod('setDrawEnable', { enable });
    }
}
export default new TxEducationEngine();
