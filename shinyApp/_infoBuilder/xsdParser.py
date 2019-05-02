import xml.etree.ElementTree as ET

tree = ET.parse('xsdFiles/eml-software.xsd')
root = tree.getroot()

ns = {'xs':'http://www.w3.org/2001/XMLSchema'}

def depth(elem, node, d):
    children =  node.findall('xs:element',ns)
    if children == []:
        return(d)
    for c in children:
        if elem.attrib['name'] == c.attrib['name']:
            return d
        else:
            return(depth(elem=elem, node=c, d=d+1))

for elem in root.iter():
    if('element' in elem.tag):
        print("######################################################")
        deep = depth(elem, root, 0)
        print(deep)
        print(elem.attrib['name'])
