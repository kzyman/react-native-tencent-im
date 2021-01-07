import React from 'react';
import { requireNativeComponent } from 'react-native';
const TICBridgeView = requireNativeComponent('TICBridgeView');
export default RCTTICBridgeView = (props) => {
    return <TICBridgeView style={props.style} />;
};
