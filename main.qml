import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    visible: true
    GridView {
        id: poolView
        property var pool: []
        cacheBuffer: 0 //force only use of custom pool
        anchors.fill: parent
        model: 12
        delegate: Item{
            id: holder
            property var current: Item{}
            Component.onCompleted: {
                if (poolView.pool.length === 0) {
                    console.debug("create new", poolView.pool.length)
                    Qt.createQmlObject('import QtQuick 2.0; Text {color: "red"; text: index}',
                                                   holder,
                                                   "dynamicSnippet1");
                                                   console.log(holder.current)
                } else {
                    console.debug("use from pool", holder.current)
                    console.debug("pool before pop: ", poolView.pool)
                    holder.current = poolView.pool.pop();
                    holder.current.parent = holder
                    console.debug(holder.current)
                }
                holder.current.visible = true
            }

            Component.onDestruction: {
                console.debug("push to pool", holder.current)
                holder.current.visible = false
                poolView.pool.push(holder.current)
                console.debug("pool after push:", poolView.pool)
            }
        }
    }
}
