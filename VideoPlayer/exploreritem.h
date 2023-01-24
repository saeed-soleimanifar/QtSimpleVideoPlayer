#ifndef EXPLORERITEM_H
#define EXPLORERITEM_H

#include <QFileInfo>
class ExplorerItem {
public:

    ExplorerItem(const QFileInfo &info)
    {
        mFileName = info.fileName();
        mFilePath = info.filePath();
        mIsDir = info.isDir();
        mIsFile = info.isFile();
    }
    ~ExplorerItem()
    {}

    inline QString fileName() const { return mFileName; }
    inline QString filePath() const { return mFilePath; }
    inline bool isDir() const { return mIsDir; }
    inline bool isFile() const { return mIsFile; }

    inline bool operator !=(const ExplorerItem &fileInfo) const {
        return !operator==(fileInfo);
    }
    bool operator ==(const ExplorerItem &property) const {
        return ((mFileName == property.mFileName) && (isDir() == property.isDir()));
    }

private:
    QString mFileName;
    QString mFilePath;
    bool mIsDir;
    bool mIsFile;
};


#endif // EXPLORERITEM_H
